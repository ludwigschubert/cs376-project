//
//  Date+iso8601.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 12/11/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

extension Date {

  struct DefaultFormatter {

    static let iso8601: DateFormatter = {
      let formatter = DateFormatter()
      formatter.calendar = Calendar(identifier: .iso8601)
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = TimeZone(identifier: "America/San_Francisco")
      formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
      return formatter
    }()

    static let urlSafe: DateFormatter = {
      let formatter = DateFormatter()
      formatter.calendar = Calendar(identifier: .iso8601)
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.timeZone = TimeZone(identifier: "America/San_Francisco")
      formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss_SSSXXXXX"
      return formatter
    }()

  }

  var iso8601: String {
    return DefaultFormatter.iso8601.string(from: self)
  }

  var urlSafeString: String {
    return DefaultFormatter.urlSafe.string(from: self)
  }

}
