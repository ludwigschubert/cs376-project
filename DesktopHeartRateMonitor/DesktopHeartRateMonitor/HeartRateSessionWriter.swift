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
        let participantName = heartRateSession.participantName
        let fileName = "\(participantName)_\(dateString).txt"

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent("Heart Rate Sessions").appendingPathComponent(fileName)

            do {
                try valuesString.write(to: path, atomically: false, encoding: String.Encoding.utf8)
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

        outputString += heartRateSession.bpmValues.map { (bpm) -> String in
            String(bpm)
        }.joined(separator: "\n")

        return outputString
    }

}
