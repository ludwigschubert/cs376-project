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
    var bpmValues:[Int] = [];

    func record(bpmValue:Int) {
        bpmValues.append(bpmValue)
    }

    func end() {
        endedOn = Date.init()
    }
}
