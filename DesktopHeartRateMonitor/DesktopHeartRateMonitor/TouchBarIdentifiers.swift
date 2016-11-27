//
//  TouchBarIdentifiers.swift
//  TouchBar
//
//  Created by Andy Pereira on 10/31/16.
//  Copyright © 2016 Ray Wenderlich. All rights reserved.
//

import AppKit

extension NSTouchBarItemIdentifier {
  static let heartRateLabelItem = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.heartRateLabel")
  static let heartRateLineChartItem = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.heartRateLineChartLabel")
  static let heartRateStatusLabelItem = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.heartRateStatusLabel")
  static let heartRateIndicatorItem1 = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.hri1")
  static let heartRateIndicatorItem2 = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.hri2")
  static let heartRateIndicatorItem3 = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.hri3")
  static let heartRateIndicatorItem4 = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.hri4")
  static let heartRateIndicatorItem5 = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.hri5")
}

extension NSTouchBarCustomizationIdentifier {
  static let heartRateBar = NSTouchBarCustomizationIdentifier("edu.stanford.cs.cs376.heart-rate-monitor.touchBarCustomizationIdentifier")
}
