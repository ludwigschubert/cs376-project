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
        Question.init(text: "4 × 68", answer: "272"),
        Question.init(text: "28 ÷ 4", answer: "7"),
        Question.init(text: "276 ÷ 6", answer: "46"),
        Question.init(text: "430 ÷ 10", answer: "43"),
        Question.init(text: "9 + 86", answer: "95"),
        Question.init(text: "5 × 10", answer: "50"),
        Question.init(text: "87 – 63", answer: "24"),
        Question.init(text: "300 ÷ 10", answer: "30"),
        Question.init(text: "180 ÷ 12", answer: "15"),
        Question.init(text: "94 + 96", answer: "190"),
        Question.init(text: "516 ÷ 6", answer: "86"),
        Question.init(text: "88 + 31", answer: "119"),
        Question.init(text: "671 ÷ 11", answer: "61"),
        Question.init(text: "55 + 41", answer: "96"),
        Question.init(text: "336 ÷ 12", answer: "28"),
        Question.init(text: "5 × 92", answer: "460"),
        Question.init(text: "20 – 4", answer: "16"),
        Question.init(text: "504 ÷ 8", answer: "63"),
        Question.init(text: "97 + 33", answer: "130"),
        Question.init(text: "98 – 2", answer: "96"),
        Question.init(text: "550 ÷ 10", answer: "55"),
        Question.init(text: "5 × 43", answer: "215"),
        Question.init(text: "58 + 41", answer: "99"),
        Question.init(text: "10 × 12", answer: "120"),
        Question.init(text: "7 × 71", answer: "497"),
        Question.init(text: "12 × 86", answer: "1032"),
        Question.init(text: "90 ÷ 2", answer: "45"),
        Question.init(text: "7 × 78", answer: "546"),
        Question.init(text: "103 – 78", answer: "25"),
        Question.init(text: "49 + 42", answer: "91"),
        Question.init(text: "108 – 71", answer: "37"),
        Question.init(text: "113 – 72", answer: "41"),
        Question.init(text: "9 + 45", answer: "54"),
        Question.init(text: "74 + 29", answer: "103"),
        Question.init(text: "8 × 46", answer: "368"),
        Question.init(text: "103 – 16", answer: "87"),
        Question.init(text: "88 ÷ 11", answer: "8"),
        Question.init(text: "6 × 26", answer: "156"),
        Question.init(text: "5 × 12", answer: "60"),
        Question.init(text: "49 – 30", answer: "19"),
        Question.init(text: "15 – 7", answer: "8"),
        Question.init(text: "330 ÷ 5", answer: "66"),
        Question.init(text: "420 ÷ 5", answer: "84"),
        Question.init(text: "41 – 12", answer: "29"),
        Question.init(text: "83 + 12", answer: "95"),
        Question.init(text: "12 × 37", answer: "444"),
        Question.init(text: "4 + 3", answer: "7"),
        Question.init(text: "98 – 43", answer: "55"),
        Question.init(text: "11 + 91", answer: "102"),
        Question.init(text: "122 – 82", answer: "40"),
        Question.init(text: "2 + 56", answer: "58"),
        Question.init(text: "144 ÷ 3", answer: "48"),
        Question.init(text: "70 ÷ 7", answer: "10"),
        Question.init(text: "9 × 66", answer: "594"),
        Question.init(text: "53 – 48", answer: "5"),
        Question.init(text: "75 – 30", answer: "45"),
        Question.init(text: "310 ÷ 10", answer: "31"),
        Question.init(text: "5 × 53", answer: "265"),
        Question.init(text: "8 × 47", answer: "376"),
        Question.init(text: "12 × 58", answer: "696")
      ],
      [
        Question.init(text: "189 – 95", answer: "94"),
        Question.init(text: "246 ÷ 3", answer: "82"),
        Question.init(text: "37 – 25", answer: "12"),
        Question.init(text: "4 × 30", answer: "120"),
        Question.init(text: "264 ÷ 8", answer: "33"),
        Question.init(text: "84 – 10", answer: "74"),
        Question.init(text: "59 – 41", answer: "18"),
        Question.init(text: "67 – 10", answer: "57"),
        Question.init(text: "10 × 21", answer: "210"),
        Question.init(text: "12 × 49", answer: "588"),
        Question.init(text: "30 + 57", answer: "87"),
        Question.init(text: "110 – 29", answer: "81"),
        Question.init(text: "140 – 51", answer: "89"),
        Question.init(text: "8 × 23", answer: "184"),
        Question.init(text: "59 – 15", answer: "44"),
        Question.init(text: "9 × 84", answer: "756"),
        Question.init(text: "10 × 99", answer: "990"),
        Question.init(text: "98 – 34", answer: "64"),
        Question.init(text: "80 + 44", answer: "124"),
        Question.init(text: "300 ÷ 12", answer: "25"),
        Question.init(text: "252 ÷ 6", answer: "42"),
        Question.init(text: "8 × 31", answer: "248"),
        Question.init(text: "96 – 76", answer: "20"),
        Question.init(text: "99 + 11", answer: "110"),
        Question.init(text: "117 – 92", answer: "25"),
        Question.init(text: "11 + 87", answer: "98"),
        Question.init(text: "7 × 31", answer: "217"),
        Question.init(text: "18 + 36", answer: "54"),
        Question.init(text: "93 + 41", answer: "134"),
        Question.init(text: "9 × 67", answer: "603"),
        Question.init(text: "27 ÷ 9", answer: "3"),
        Question.init(text: "71 – 25", answer: "46"),
        Question.init(text: "8 × 19", answer: "152"),
        Question.init(text: "32 + 72", answer: "104"),
        Question.init(text: "4 × 45", answer: "180"),
        Question.init(text: "66 – 58", answer: "8"),
        Question.init(text: "11 × 62", answer: "682"),
        Question.init(text: "9 × 59", answer: "531"),
        Question.init(text: "64 – 22", answer: "42"),
        Question.init(text: "70 ÷ 2", answer: "35"),
        Question.init(text: "5 × 6", answer: "30"),
        Question.init(text: "12 × 34", answer: "408"),
        Question.init(text: "49 + 41", answer: "90"),
        Question.init(text: "87 – 41", answer: "46"),
        Question.init(text: "3 × 79", answer: "237"),
        Question.init(text: "94 + 56", answer: "150"),
        Question.init(text: "4 × 12", answer: "48"),
        Question.init(text: "728 ÷ 8", answer: "91"),
        Question.init(text: "900 ÷ 10", answer: "90"),
        Question.init(text: "357 ÷ 7", answer: "51"),
        Question.init(text: "748 ÷ 11", answer: "68"),
        Question.init(text: "10 + 25", answer: "35"),
        Question.init(text: "115 – 61", answer: "54"),
        Question.init(text: "20 + 21", answer: "41"),
        Question.init(text: "52 + 40", answer: "92"),
        Question.init(text: "132 ÷ 2", answer: "66"),
        Question.init(text: "572 ÷ 11", answer: "52"),
        Question.init(text: "101 – 19", answer: "82"),
        Question.init(text: "9 × 43", answer: "387"),
        Question.init(text: "12 + 94", answer: "106")
      ],
      [
        Question.init(text: "120 – 77", answer: "43"),
        Question.init(text: "116 – 38", answer: "78"),
        Question.init(text: "86 – 34", answer: "52"),
        Question.init(text: "86 – 34", answer: "52"),
        Question.init(text: "58 – 37", answer: "21"),
        Question.init(text: "66 + 65", answer: "131"),
        Question.init(text: "10 × 71", answer: "710"),
        Question.init(text: "5 × 50", answer: "250"),
        Question.init(text: "470 ÷ 10", answer: "47"),
        Question.init(text: "7 × 17", answer: "119"),
        Question.init(text: "7 × 3", answer: "21"),
        Question.init(text: "3 × 9", answer: "27"),
        Question.init(text: "99 + 9", answer: "108"),
        Question.init(text: "60 ÷ 4", answer: "15"),
        Question.init(text: "9 – 6", answer: "3"),
        Question.init(text: "15 + 33", answer: "48"),
        Question.init(text: "648 ÷ 9", answer: "72"),
        Question.init(text: "768 ÷ 12", answer: "64"),
        Question.init(text: "76 – 63", answer: "13"),
        Question.init(text: "474 ÷ 6", answer: "79"),
        Question.init(text: "10 × 45", answer: "450"),
        Question.init(text: "31 + 79", answer: "110"),
        Question.init(text: "9 × 11", answer: "99"),
        Question.init(text: "135 – 83", answer: "52"),
        Question.init(text: "12 × 20", answer: "240"),
        Question.init(text: "80 – 63", answer: "17"),
        Question.init(text: "11 × 96", answer: "1056"),
        Question.init(text: "62 + 90", answer: "152"),
        Question.init(text: "4 × 94", answer: "376"),
        Question.init(text: "48 – 38", answer: "10"),
        Question.init(text: "72 ÷ 4", answer: "18"),
        Question.init(text: "6 × 44", answer: "264"),
        Question.init(text: "91 – 32", answer: "59"),
        Question.init(text: "36 ÷ 9", answer: "4"),
        Question.init(text: "5 × 18", answer: "90"),
        Question.init(text: "42 + 89", answer: "131"),
        Question.init(text: "2 × 70", answer: "140"),
        Question.init(text: "616 ÷ 11", answer: "56"),
        Question.init(text: "67 + 11", answer: "78"),
        Question.init(text: "62 + 50", answer: "112"),
        Question.init(text: "129 – 60", answer: "69"),
        Question.init(text: "80 ÷ 5", answer: "16"),
        Question.init(text: "200 ÷ 4", answer: "50"),
        Question.init(text: "744 ÷ 12", answer: "62"),
        Question.init(text: "156 ÷ 12", answer: "13"),
        Question.init(text: "670 ÷ 10", answer: "67"),
        Question.init(text: "9 × 87", answer: "783"),
        Question.init(text: "828 ÷ 9", answer: "92"),
        Question.init(text: "12 ÷ 2", answer: "6"),
        Question.init(text: "5 × 20", answer: "100"),
        Question.init(text: "7 × 65", answer: "455"),
        Question.init(text: "162 ÷ 6", answer: "27"),
        Question.init(text: "27 + 47", answer: "74"),
        Question.init(text: "14 ÷ 7", answer: "2"),
        Question.init(text: "9 × 24", answer: "216"),
        Question.init(text: "92 – 38", answer: "54"),
        Question.init(text: "102 – 36", answer: "66"),
        Question.init(text: "5 × 58", answer: "290"),
        Question.init(text: "10 × 42", answer: "420"),
        Question.init(text: "12 + 17", answer: "29")
      ],
      [
        Question.init(text: "45 + 87", answer: "132"),
        Question.init(text: "504 ÷ 7", answer: "72"),
        Question.init(text: "83 + 11", answer: "94"),
        Question.init(text: "10 × 77", answer: "770"),
        Question.init(text: "6 × 8", answer: "48"),
        Question.init(text: "200 ÷ 2", answer: "100"),
        Question.init(text: "10 × 37", answer: "370"),
        Question.init(text: "960 ÷ 10", answer: "96"),
        Question.init(text: "42 – 16", answer: "26"),
        Question.init(text: "7 × 35", answer: "245"),
        Question.init(text: "69 – 37", answer: "32"),
        Question.init(text: "103 – 66", answer: "37"),
        Question.init(text: "12 × 85", answer: "1020"),
        Question.init(text: "930 ÷ 10", answer: "93"),
        Question.init(text: "46 – 14", answer: "32"),
        Question.init(text: "95 – 68", answer: "27"),
        Question.init(text: "18 + 87", answer: "105"),
        Question.init(text: "50 – 3", answer: "47"),
        Question.init(text: "24 + 50", answer: "74"),
        Question.init(text: "10 × 79", answer: "790"),
        Question.init(text: "5 × 32", answer: "160"),
        Question.init(text: "10 × 46", answer: "460"),
        Question.init(text: "42 – 11", answer: "31"),
        Question.init(text: "14 + 14", answer: "28"),
        Question.init(text: "143 – 97", answer: "46"),
        Question.init(text: "425 ÷ 5", answer: "85"),
        Question.init(text: "89 + 64", answer: "153"),
        Question.init(text: "7 × 15", answer: "105"),
        Question.init(text: "245 ÷ 7", answer: "35"),
        Question.init(text: "468 ÷ 12", answer: "39"),
        Question.init(text: "153 – 83", answer: "70"),
        Question.init(text: "165 – 73", answer: "92"),
        Question.init(text: "236 ÷ 4", answer: "59"),
        Question.init(text: "7 × 46", answer: "322"),
        Question.init(text: "120 ÷ 5", answer: "24"),
        Question.init(text: "736 ÷ 8", answer: "92"),
        Question.init(text: "47 + 14", answer: "61"),
        Question.init(text: "58 – 8", answer: "50"),
        Question.init(text: "97 + 72", answer: "169"),
        Question.init(text: "15 – 7", answer: "8"),
        Question.init(text: "83 + 46", answer: "129"),
        Question.init(text: "102 – 36", answer: "66"),
        Question.init(text: "10 × 99", answer: "990"),
        Question.init(text: "213 ÷ 3", answer: "71"),
        Question.init(text: "12 × 25", answer: "300"),
        Question.init(text: "8 × 56", answer: "448"),
        Question.init(text: "140 ÷ 10", answer: "14"),
        Question.init(text: "77 + 97", answer: "174"),
        Question.init(text: "12 ÷ 4", answer: "3"),
        Question.init(text: "6 × 52", answer: "312"),
        Question.init(text: "38 ÷ 2", answer: "19"),
        Question.init(text: "73 + 15", answer: "88"),
        Question.init(text: "11 × 92", answer: "1012"),
        Question.init(text: "9 × 29", answer: "261"),
        Question.init(text: "18 + 92", answer: "110"),
        Question.init(text: "18 ÷ 9", answer: "2"),
        Question.init(text: "7 × 59", answer: "413"),
        Question.init(text: "11 × 13", answer: "143"),
        Question.init(text: "80 + 61", answer: "141"),
        Question.init(text: "8 ÷ 2", answer: "4")
    ],
    [
        Question.init(text: "5 × 10", answer: "50"),
        Question.init(text: "95 + 85", answer: "180"),
        Question.init(text: "297 ÷ 3", answer: "99"),
        Question.init(text: "119 – 74", answer: "45"),
        Question.init(text: "91 + 40", answer: "131"),
        Question.init(text: "6 × 46", answer: "276"),
        Question.init(text: "387 ÷ 9", answer: "43"),
        Question.init(text: "115 – 81", answer: "34"),
        Question.init(text: "960 ÷ 12", answer: "80"),
        Question.init(text: "33 + 36", answer: "69"),
        Question.init(text: "119 – 49", answer: "70"),
        Question.init(text: "3 × 60", answer: "180"),
        Question.init(text: "191 – 100", answer: "91"),
        Question.init(text: "132 ÷ 4", answer: "33"),
        Question.init(text: "71 + 6", answer: "77"),
        Question.init(text: "210 ÷ 5", answer: "42"),
        Question.init(text: "87 + 88", answer: "175"),
        Question.init(text: "6 × 14", answer: "84"),
        Question.init(text: "3 + 62", answer: "65"),
        Question.init(text: "100 ÷ 10", answer: "10"),
        Question.init(text: "66 + 32", answer: "98"),
        Question.init(text: "15 + 40", answer: "55"),
        Question.init(text: "123 ÷ 3", answer: "41"),
        Question.init(text: "7 × 55", answer: "385"),
        Question.init(text: "10 × 85", answer: "850"),
        Question.init(text: "81 + 8", answer: "89"),
        Question.init(text: "53 + 26", answer: "79"),
        Question.init(text: "196 ÷ 4", answer: "49"),
        Question.init(text: "12 × 55", answer: "660"),
        Question.init(text: "154 ÷ 11", answer: "14"),
        Question.init(text: "414 ÷ 9", answer: "46"),
        Question.init(text: "138 – 73", answer: "65"),
        Question.init(text: "405 ÷ 9", answer: "45"),
        Question.init(text: "31 + 11", answer: "42"),
        Question.init(text: "308 ÷ 11", answer: "28"),
        Question.init(text: "67 – 64", answer: "3"),
        Question.init(text: "432 ÷ 6", answer: "72"),
        Question.init(text: "10 × 50", answer: "500"),
        Question.init(text: "11 × 74", answer: "814"),
        Question.init(text: "12 × 51", answer: "612"),
        Question.init(text: "22 – 4", answer: "18"),
        Question.init(text: "79 – 8", answer: "71"),
        Question.init(text: "70 + 16", answer: "86"),
        Question.init(text: "420 ÷ 6", answer: "70"),
        Question.init(text: "282 ÷ 6", answer: "47"),
        Question.init(text: "512 ÷ 8", answer: "64"),
        Question.init(text: "9 × 76", answer: "684"),
        Question.init(text: "45 – 2", answer: "43"),
        Question.init(text: "2 × 97", answer: "194"),
        Question.init(text: "134 – 92", answer: "42"),
        Question.init(text: "693 ÷ 7", answer: "99"),
        Question.init(text: "7 × 74", answer: "518"),
        Question.init(text: "31 – 23", answer: "8"),
        Question.init(text: "115 – 77", answer: "38"),
        Question.init(text: "4 × 57", answer: "228"),
        Question.init(text: "31 + 65", answer: "96"),
        Question.init(text: "58 + 32", answer: "90"),
        Question.init(text: "243 ÷ 3", answer: "81"),
        Question.init(text: "99 + 36", answer: "135"),
        Question.init(text: "253 ÷ 11", answer: "23")
        ],
    [
        Question.init(text: "10 × 38", answer: "380"),
        Question.init(text: "60 ÷ 5", answer: "12"),
        Question.init(text: "91 – 23", answer: "68"),
        Question.init(text: "405 ÷ 5", answer: "81"),
        Question.init(text: "10 + 77", answer: "87"),
        Question.init(text: "4 × 86", answer: "344"),
        Question.init(text: "120 – 73", answer: "47"),
        Question.init(text: "7 × 69", answer: "483"),
        Question.init(text: "111 – 66", answer: "45"),
        Question.init(text: "6 × 8", answer: "48"),
        Question.init(text: "71 + 76", answer: "147"),
        Question.init(text: "11 × 16", answer: "176"),
        Question.init(text: "188 ÷ 4", answer: "47"),
        Question.init(text: "38 + 12", answer: "50"),
        Question.init(text: "36 ÷ 3", answer: "12"),
        Question.init(text: "8 × 98", answer: "784"),
        Question.init(text: "16 + 35", answer: "51"),
        Question.init(text: "11 × 89", answer: "979"),
        Question.init(text: "132 – 38", answer: "94"),
        Question.init(text: "8 + 99", answer: "107"),
        Question.init(text: "32 ÷ 2", answer: "16"),
        Question.init(text: "78 + 37", answer: "115"),
        Question.init(text: "231 ÷ 3", answer: "77"),
        Question.init(text: "7 × 15", answer: "105"),
        Question.init(text: "2 × 40", answer: "80"),
        Question.init(text: "112 ÷ 4", answer: "28"),
        Question.init(text: "3 × 51", answer: "153"),
        Question.init(text: "7 × 89", answer: "623"),
        Question.init(text: "730 ÷ 10", answer: "73"),
        Question.init(text: "88 + 95", answer: "183"),
        Question.init(text: "4 × 55", answer: "220"),
        Question.init(text: "87 – 10", answer: "77"),
        Question.init(text: "7 × 32", answer: "224"),
        Question.init(text: "147 – 71", answer: "76"),
        Question.init(text: "9 × 21", answer: "189"),
        Question.init(text: "6 × 33", answer: "198"),
        Question.init(text: "7 × 33", answer: "231"),
        Question.init(text: "69 + 91", answer: "160"),
        Question.init(text: "129 ÷ 3", answer: "43"),
        Question.init(text: "123 – 59", answer: "64"),
        Question.init(text: "57 + 5", answer: "62"),
        Question.init(text: "378 ÷ 9", answer: "42"),
        Question.init(text: "12 × 76", answer: "912"),
        Question.init(text: "3 × 12", answer: "36"),
        Question.init(text: "73 + 95", answer: "168"),
        Question.init(text: "53 + 72", answer: "125"),
        Question.init(text: "12 × 24", answer: "288"),
        Question.init(text: "53 + 62", answer: "115"),
        Question.init(text: "60 – 24", answer: "36"),
        Question.init(text: "18 ÷ 6", answer: "3"),
        Question.init(text: "10 × 65", answer: "650"),
        Question.init(text: "91 + 38", answer: "129"),
        Question.init(text: "10 × 67", answer: "670"),
        Question.init(text: "8 × 67", answer: "536"),
        Question.init(text: "6 × 7", answer: "42"),
        Question.init(text: "540 ÷ 6", answer: "90"),
        Question.init(text: "558 ÷ 9", answer: "62"),
        Question.init(text: "3 × 23", answer: "69"),
        Question.init(text: "580 ÷ 10", answer: "58"),
        Question.init(text: "20 + 65", answer: "85")
        ]
        
    ]
  }
}
