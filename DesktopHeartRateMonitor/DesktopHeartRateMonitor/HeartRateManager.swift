//
//  HeartRateManager.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 11/21/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

extension Notification.Name {
  static let calibrationStatusChanged = Notification.Name("HeartRateManagerCalibrationStatusChanged")
  static let heartRateStatusChanged   = Notification.Name("HeartRateManagerHeartRateStatusChanged")
  static let receivedHeartRate        = Notification.Name("HeartRateManagerReceivedHeartRate")
}

enum HeartRateStatus {
  case VeryLow
  case Low
  case Normal
  case High
  case VeryHigh
}

enum CalibrationStatus {
  case NotYetStarted
  case Ongoing
  case Finished
}

class HeartRateManager : HeartRateSensorDelegate {

  private let surgeMultiplicator = 1.0 + 0.2
  private var baseLFHFRatio : Double?
  private var calibrationStatus = CalibrationStatus.NotYetStarted
  private var lfhfRatioStatus = HeartRateStatus.Normal
  private let windowSize = 150
  private var heartRateHistory : [Double] = []
  private var rrHistory : [Double] = []
  private let concurrentQueue = DispatchQueue(label: "spectrum-analysis", attributes: .concurrent)
  private let nc = NotificationCenter.default

  //MARK:- HeartRateSensorDelegate Methods

  func didReceive(heartRateInfo: HeartRateInfo, sender: HeartRateSensor)
  {
    heartRateHistory.append(Double(heartRateInfo.heartRate))
    rrHistory.append(Double(heartRateInfo.rr))

    if rrHistory.count >= windowSize && heartRateHistory.count % 5 == 0 {
      analyzeLFHFRatio()
    }

    switch calibrationStatus {
    case .NotYetStarted:
      calibrationStatus = .Ongoing
      nc.post(name: .calibrationStatusChanged, object: nil,
              userInfo: ["calibrationStatus": calibrationStatus])
      break
    case .Ongoing:
      nc.post(name: .calibrationStatusChanged, object: nil,
              userInfo: ["calibrationStatus": calibrationStatus, "σ": heartRateInfo.rr])
      break
    case .Finished:
      nc.post(name: .receivedHeartRate, object: nil,
              userInfo: ["heartRateInfo": heartRateInfo, "average": baseLFHFRatio!])
      break
    }
  }

  func analyzeLFHFRatio() {
    let rrSubset = Array(rrHistory.suffix(windowSize))
//    print("Analyzing spectra on rrHistory with count \(rrHistory.count), windowed to \(rrSubset.count).")
    concurrentQueue.async {
      let spectrumData = SpectrumAnalyzer.process(rrSubset)
      if let spectrumData = spectrumData {
        DispatchQueue.main.async {
          let lf = spectrumData.lf
          let hf = spectrumData.hf
          let lfhf = lf/hf
          self.LFHFRatioWasUpdated(lfhfRatio: lfhf)
        }
      } else {
        print("Error analyzing spectrum data!?")
      }
    }
  }

  func LFHFRatioWasUpdated(lfhfRatio: Double) {
    if (baseLFHFRatio == nil) {
      baseLFHFRatio = lfhfRatio
    }

    if calibrationStatus == .Ongoing {
      calibrationStatus = .Finished
      nc.post(name: .calibrationStatusChanged, object: nil,
              userInfo: ["calibrationStatus": calibrationStatus])
    }
//    print("base", baseLFHFRatio!)
//    print("now", lfhfRatio)

    let newStatus = LFHFRatioStatus(lfhfRatio: lfhfRatio)
    print(newStatus)
    if newStatus != lfhfRatioStatus {
      lfhfRatioStatus = newStatus
      nc.post(name: .heartRateStatusChanged, object: nil,
              userInfo: ["heartRateStatus": lfhfRatioStatus])

    }

  }

  func LFHFRatioStatus(lfhfRatio: Double) -> HeartRateStatus
  {
    guard let baseLFHFRatio = baseLFHFRatio else {
      return HeartRateStatus.Normal
    }

    if lfhfRatio > 2 * baseLFHFRatio {
      return HeartRateStatus.VeryLow
    } else if lfhfRatio > 1.5 * baseLFHFRatio {
      return HeartRateStatus.Low
    } else if lfhfRatio < baseLFHFRatio * 0.55 {
      return HeartRateStatus.VeryHigh
    } else if lfhfRatio < baseLFHFRatio * 0.7 {
      return HeartRateStatus.High
    } else {
      return HeartRateStatus.Normal
    }
  }

}
