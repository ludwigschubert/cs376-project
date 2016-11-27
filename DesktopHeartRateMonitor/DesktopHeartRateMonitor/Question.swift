//
//  Question.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 11/1/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

class Question: NSObject {

  let text: String
  let answer: String

  init(text: String, answer: String) {
    self.text = text
    self.answer = answer
  }

  static func examples() -> Array<Array<Question>> {
    return [
      [
        Question.init(text: "Set 1, Question 1: 42=", answer: "42"),
        Question.init(text: "Set 1, Question 2: 42=", answer: "42"),
        Question.init(text: "Set 1, Question 3: 42=", answer: "42")
      ],
      [
        Question.init(text: "Set 2, Question 1: 42=", answer: "42"),
        Question.init(text: "Set 2, Question 2: 42=", answer: "42"),
        Question.init(text: "Set 2, Question 3: 42=", answer: "42")
      ],
      [
        Question.init(text: "Set 3, Question 1: 42=", answer: "42"),
        Question.init(text: "Set 3, Question 2: 42=", answer: "42"),
        Question.init(text: "Set 3, Question 3: 42=", answer: "42")
      ],
      [
        Question.init(text: "Set 4, Question 1: 42=", answer: "42"),
        Question.init(text: "Set 4, Question 2: 42=", answer: "42"),
        Question.init(text: "Set 4, Question 3: 42=", answer: "42")
      ]
    ]
  }
}
