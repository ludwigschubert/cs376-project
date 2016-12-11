//
//  Array+statistics.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 12/11/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

extension Array where Element: FloatingPoint {

  /// Returns the sum of all elements in the array
  var total: Element {
    return reduce(0, +)
  }

  /// Returns the average of all elements in the array
  var average: Element {
    return isEmpty ? 0 : total / Element(count)
  }

}
