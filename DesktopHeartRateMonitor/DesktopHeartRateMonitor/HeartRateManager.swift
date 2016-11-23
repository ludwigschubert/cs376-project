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
    case Low
    case Normal
    case High
}

enum CalibrationStatus {
    case NotYetStarted
    case Ongoing
    case Finished
}

class HeartRateManager : HeartRateSensorDelegate {

    private let surgeMultiplicator = 1.0 + 0.2
    private var baseHeartRate : Double?
    private var calibrationStatus = CalibrationStatus.NotYetStarted
    private var heartRateStatus = HeartRateStatus.Normal
    private let heartRateQueue = HeartRateQueue()

    //MARK:- HeartRateSensorDelegate Methods

    func didReceive(bpm: Int, sender: HeartRateSensor)
    {
        heartRateQueue.record(bpm: bpm)

        switch calibrationStatus {
        case .NotYetStarted:
            calibrationStatus = .Ongoing
//            print("calibrationStatusChanged: Ongoing")
            NotificationCenter.default.post(name: .calibrationStatusChanged,
                                            object: calibrationStatus)
            break
        case .Ongoing:
            let σ = heartRateQueue.standardDeviation()
            print("calibrationStatus: σ ", σ)
            if true{//heartRateQueue.full() && σ < 8.0 {
                baseHeartRate = heartRateQueue.average()
                calibrationStatus = .Finished
//                print("calibrationStatusChanged: Finished ", baseHeartRate!)
                NotificationCenter.default.post(name: .calibrationStatusChanged,
                                                object: calibrationStatus)
            }
            break
        case .Finished:
            let newHeartRateStatus = heartRateStatus(bpm: bpm)
            if newHeartRateStatus != heartRateStatus {
                heartRateStatus = newHeartRateStatus
//                print("heartRateStatusChanged: ", heartRateStatus)
                NotificationCenter.default.post(name: .heartRateStatusChanged,
                                                object: nil,
                                                userInfo: ["heartRateStatus": heartRateStatus])
            }
            NotificationCenter.default.post(name: .receivedHeartRate,
                                            object: nil,
                                            userInfo: ["bpm": bpm])
            break
        }
    }

    func heartRateStatus(bpm: Int) -> HeartRateStatus
    {
        if let baseHeartRate = baseHeartRate {
            if Double(bpm) > surgeMultiplicator * baseHeartRate {
                return HeartRateStatus.High
            } else if Double(bpm) < baseHeartRate * (1 - surgeMultiplicator) {
                return HeartRateStatus.Low
            }
        }
        // Either if within normal range, or if we don't have data yet
        return HeartRateStatus.Normal
    }

}

class HeartRateQueue {

    private let maxNumberOfHeartRates = 10
    private var heartRateHistory : [Double] = []

    func record(bpm: Int)
    {
        heartRateHistory.append(Double(bpm))
        if heartRateHistory.count > maxNumberOfHeartRates {
            heartRateHistory.remove(at: 0)
        }
    }

    func full() -> Bool
    {
        return heartRateHistory.count == maxNumberOfHeartRates
    }

    func average() -> Double
    {
        let length = Double(heartRateHistory.count)
        return heartRateHistory.reduce(0, +) / length
    }

    func standardDeviation() -> Double
    {
        let length = Double(heartRateHistory.count)
        let avg = heartRateHistory.reduce(0, +) / length
        let sumOfSquaredAvgDiff = heartRateHistory.map{pow($0 - avg, 2.0)}.reduce(0, +)
        return sqrt(sumOfSquaredAvgDiff / length)
    }
}
