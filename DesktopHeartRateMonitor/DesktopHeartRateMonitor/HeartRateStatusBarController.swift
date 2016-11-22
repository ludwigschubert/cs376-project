//
//  HeartRateStatusBarViewController.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 11/21/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation
import Cocoa

class HeartRateStatusBarController: NSObject {

    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem = NSStatusBar.system().statusItem(withLength: 88.0)
    let menu = NSMenu()

    override init() {
        super.init()
        if let button = statusItem.button {
            button.title = "Hallo Test"
        }
//        let view = NSView()
//        view.layer?.backgroundColor = NSColor.red.cgColor
//        statusItem.view = view

        NotificationCenter.default.addObserver(self, selector: #selector(HeartRateStatusBarController.didReceiveHeartRate),
                                               name: Notification.Name.receivedHeartRate, object: nil)
    }

    func didReceiveHeartRate(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let bpm : Int = userInfo["bpm"] as! Int?,
              let button = statusItem.button else {
            return
        }
        button.title = "bpm: \(bpm)"
    }

}
