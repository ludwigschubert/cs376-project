//
//  ViewControllerTouchBarExtension.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 11/22/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Cocoa

extension ViewController: NSTouchBarDelegate {

    override func makeTouchBar() -> NSTouchBar?
    {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = .heartRateBar
        touchBar.defaultItemIdentifiers = [.heartRateLabelItem, .heartRateStatusLabelItem]
        touchBar.customizationAllowedItemIdentifiers = touchBar.defaultItemIdentifiers
        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        switch identifier {
        case NSTouchBarItemIdentifier.heartRateLabelItem:
            let customViewItem = NSCustomTouchBarItem(identifier: identifier)
            let textField = NSTextField(labelWithString: "HI THERE")
            //            textField.bind("stringValue", to: self, withKeyPath: #keyPath(touchBarString), options: nil)
            //            textField.backgroundColor = NSColor.red
            //            textField.textColor = NSColor.green
//            let imageView = NSImageView()
//            imageView.bind("image", to: self, withKeyPath: #keyPath(image), options: nil)
            customViewItem.view = textField
            return customViewItem
        default:
            return nil
        }
    }
}
