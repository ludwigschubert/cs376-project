//
//  HeartRateSessionWriter.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 10/30/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

class HeartRateSessionWriter: NSObject {

    static func write(heartRateSession: HeartRateSession)
    {
        let valuesString = serialize(heartRateSession: heartRateSession)
        let dateString = heartRateSession.startedOn.description
        let participantName = UserDefaults.standard.value(forKey: "participantName")
        let fileName = "\(participantName)_\(dateString).txt"

        if let dir = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent("Heart Rate Sessions")
            let filePath = path.appendingPathComponent(fileName)
            
            do {
                try valuesString.write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {
                print("Could not write to \(path)!")
            }

        }
    }

    static func serialize(heartRateSession: HeartRateSession) -> String
    {
        var outputString = "";

        outputString += heartRateSession.participantName + "\n"
        outputString += "started on " + heartRateSession.startedOn.description + "\n"
        outputString += "ended on " + heartRateSession.endedOn!.description + "\n"

        outputString += heartRateSession.bpmValues.map { (bpm, date) -> String in
            "\(bpm), \(date)"
        }.joined(separator: "\n")

        outputString += "\n"

        outputString += heartRateSession.answers.map { (correct, timeInterval) -> String in
            "\(correct), \(timeInterval)"
            }.joined(separator: "\n")

        return outputString
    }

}
