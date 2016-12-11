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
  var heartRateInfos:[HeartRateInfo] = [];
  var actions:[(Date, TimeInterval, String, Bool, Int)] = [];

  func record(heartRateInfo: HeartRateInfo) {
    heartRateInfos.append(heartRateInfo)
  }

  func record(date: Date, duration: TimeInterval, answer: String, correct: Bool, set: Int) {
    let entry = (date, duration, answer, correct, set)
    actions.append(entry)
  }

  func end() {
    endedOn = Date.init()
  }
}
