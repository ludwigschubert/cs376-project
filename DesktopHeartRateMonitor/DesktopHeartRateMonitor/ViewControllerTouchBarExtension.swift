//
//  ViewControllerTouchBarExtension.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 11/22/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Cocoa
//import QuartzCore

extension ViewController: NSTouchBarDelegate {

    override func makeTouchBar() -> NSTouchBar?
    {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .heartRateBar
        touchBar.defaultItemIdentifiers = [.heartRateLabelItem, .flexibleSpace, .heartRateStatusLabelItem, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge, .fixedSpaceLarge]
        touchBar.customizationAllowedItemIdentifiers = touchBar.defaultItemIdentifiers
        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.heartRateLabelItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = lineChartView
            return customViewItem
        case NSTouchBarItemIdentifier.heartRateStatusLabelItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            let textField = NSTextField(labelWithString: "HI THERE")
            textField.bind("stringValue", to: self, withKeyPath: #keyPath(bpmLabel.stringValue), options: nil)
            customViewItem.view = textField
//            customViewItem.
            return customViewItem
        default:
            return nil//NSTouchBarItem(identifier: identifier)
        }
    }
}
