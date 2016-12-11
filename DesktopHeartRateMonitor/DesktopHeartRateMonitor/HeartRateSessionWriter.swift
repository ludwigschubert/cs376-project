//
//  HeartRateSessionWriter.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 10/30/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

class HeartRateSessionWriter: NSObject {

  static let manager = FileManager.default
  static let defaults = UserDefaults.standard

  static func write(heartRateSession: HeartRateSession)
  {
    guard let dir = manager.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
      print("Can't access Downloads directory for writing session file!")
      return
    }

    let valuesString = serialize(heartRateSession)
    let file = fileName(for: heartRateSession)
    let path = dir.appendingPathComponent("Heart Rate Sessions")
    let filePath = path.appendingPathComponent(file)

    do {
      try manager.createDirectory(at: path,
                                  withIntermediateDirectories: true,
                                  attributes: nil)
      try valuesString.write(to: filePath,
                             atomically: false,
                             encoding: String.Encoding.utf8)
    } catch {
      print("Could not write at \(path)!")
    }

  }

  static func fileName(for heartRateSession: HeartRateSession) -> String{
    let date = heartRateSession.startedOn.urlSafeString
    if let participant = defaults.value(forKey: "participantName") {
      return "\(participant)_\(date).txt"
    } else {
      return "Anonymous_\(date).txt"
    }

  }

  static func serialize(_ heartRateSession: HeartRateSession) -> String
  {
    var outputString = "";

    if let participant = defaults.value(forKey: "participantName") {
      outputString += "\(participant)\n"
    }
    outputString += "started on " + heartRateSession.startedOn.iso8601 + "\n\n"
    if let endedOn = heartRateSession.endedOn {
      outputString += "ended on " + endedOn.iso8601 + "\n\n"
    }

    outputString += "Date, HR, RR\n"
    outputString += heartRateSession.heartRateInfos.map { (info) -> String in
        let fields = [info.date.iso8601,
                      info.heartRate.description,
                      info.rr.description]
        return fields.joined(separator: ", ")
      }.joined(separator: "\n")

    outputString += "\n\n"

    outputString += "Date, Duration, Answer, Correct, Set\n"
    outputString += heartRateSession.actions.map { (date, duration, answer, correct, set) -> String in
      let fields = [date.iso8601,
                    duration.description,
                    answer,
                    correct.description,
                    set.description]
      return fields.joined(separator: ", ")
      }.joined(separator: "\n")
    
    return outputString
  }
  
}
