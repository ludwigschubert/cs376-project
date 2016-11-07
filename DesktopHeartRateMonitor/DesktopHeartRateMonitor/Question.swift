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
            Question.init(text: "/* Program B */\n int x = readInt(); \n if (x >= 10000) {\n   while (x != 0) {\n      if (x % 10 != 9) {\n         println('failure');\n      }\n    x /= 10; }\n   println('success');\n}\n\nWhat is the smallest integer value for which this program prints 'success'?", answer: "99999"),
            Question.init(text: "private String mystery(String s) {\n String result = '';\n int len = s.length();\n int j = 0;\n int k = 9;\n while (j < k) {\nif (j < 4) {\n   result += s.charAt(k % len);\n}\nif (j / 2 != 1) {\n   result += s.charAt(j % len);\n}\nj++;\nk--; }\n return result;\n  }\n\nWhat is the value of mystery('abcdefg')?", answer: "cabbage"),
            Question.init(text: "test", answer: "test")
        ]
    }
}
