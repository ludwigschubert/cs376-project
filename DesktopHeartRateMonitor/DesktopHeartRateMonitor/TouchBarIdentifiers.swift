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
  static let heartRateVisualizationLabelItem = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.heartRateVisualizationLabelItem")
  static let heartRateStatusLabelItem = NSTouchBarItemIdentifier("edu.stanford.cs.cs376.hrm.heartRateStatusLabel")
}

extension NSTouchBarCustomizationIdentifier {
  static let heartRateBar = NSTouchBarCustomizationIdentifier("edu.stanford.cs.cs376.heart-rate-monitor.touchBarCustomizationIdentifier")
}
