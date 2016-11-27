//
//  AppDelegate.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 10/30/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let heartRateSensor = FakeHeartRateSensor()
    let heartRateManager = HeartRateManager()
    var viewController : ViewController!
    var statusBar : HeartRateStatusBarController?

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        // late initialization, so VCs are ready
        statusBar = HeartRateStatusBarController()

        // Connect Heart Rate Sensor
        heartRateSensor.connect()
        heartRateSensor.delegate = heartRateManager

        // Get reference of ViewController
//        let window = NSApplication.shared().mainWindow!
//        viewController = window.contentViewController! as! ViewController

        // Set up touch bar customization
        NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }

    func applicationWillTerminate(_ aNotification: Notification)
    {
        // Insert code here to tear down your application
    }


}

