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

    static func examples() -> Array<Question> {
        return [
            Question.init(text: "40 + 2", answer: "42"),
            Question.init(text: "Michael…", answer: "Bernstein"),
            Question.init(text: "HC…", answer: "I"),
            Question.init(text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.", answer: "Yes"),
        ]
    }
}
