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
        touchBar.defaultItemIdentifiers = [.heartRateIndicatorItem1, .heartRateIndicatorItem2, .heartRateIndicatorItem3, .heartRateIndicatorItem4, .heartRateIndicatorItem5, .heartRateStatusLabelItem]
        touchBar.customizationAllowedItemIdentifiers = touchBar.defaultItemIdentifiers
        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.heartRateLineChartItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            customViewItem.view = lineChartView
            return customViewItem
        case NSTouchBarItemIdentifier.heartRateStatusLabelItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            let textField = NSTextField(labelWithString: "HI THERE")
            textField.bind("stringValue", to: self, withKeyPath: #keyPath(touchBarLabelString), options: nil)
            customViewItem.view = textField
            return customViewItem
        case NSTouchBarItemIdentifier.heartRateIndicatorItem1:
          let customViewItem = NSCustomTouchBarItem(identifier: identifier)
          let image = NSImage(named: "HeartRateIndicatorLight")
          self.imageView1.image = image
          customViewItem.view = imageView1
          return customViewItem
        case NSTouchBarItemIdentifier.heartRateIndicatorItem2:
          let customViewItem = NSCustomTouchBarItem(identifier: identifier)
          let image = NSImage(named: "HeartRateIndicatorLight")
          self.imageView2.image = image
          customViewItem.view = imageView2
          return customViewItem
        case NSTouchBarItemIdentifier.heartRateIndicatorItem3:
          let customViewItem = NSCustomTouchBarItem(identifier: identifier)
          let image = NSImage(named: "HeartRateIndicatorLight")
          self.imageView3.image = image
          customViewItem.view = imageView3
          return customViewItem
        case NSTouchBarItemIdentifier.heartRateIndicatorItem4:
          let customViewItem = NSCustomTouchBarItem(identifier: identifier)
          let image = NSImage(named: "HeartRateIndicatorLight")
          self.imageView4.image = image
          customViewItem.view = imageView4
          return customViewItem
        case NSTouchBarItemIdentifier.heartRateIndicatorItem5:
          let customViewItem = NSCustomTouchBarItem(identifier: identifier)
          let image = NSImage(named: "HeartRateIndicatorLight")
          self.imageView5.image = image
          customViewItem.view = imageView5
          return customViewItem
        default:
            return nil//NSTouchBarItem(identifier: identifier)
        }
    }
}
