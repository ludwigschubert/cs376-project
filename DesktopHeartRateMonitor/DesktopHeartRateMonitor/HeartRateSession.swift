//
//  HeartRateSession.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 10/30/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

class HeartRateSession: NSObject {

    override init() {
        startedOn = Date.init();
    }

    var startedOn:Date;
    var endedOn:Date?;
    var participantName = "";
    var bpmValues:[(Int, Date)] = [];
    var answers:[(Bool, TimeInterval)] = [];

    func record(bpmValue: Int) {
        let entry = (bpmValue, Date.init())
        bpmValues.append(entry)
    }

    func record(gotAnswerCorrect: Bool, afterTimeInterval: TimeInterval) {
        let entry = (gotAnswerCorrect, afterTimeInterval)
        answers.append(entry)
    }

    func end() {
        endedOn = Date.init()
    }
}
