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

  func applicationDidFinishLaunching(_ aNotification: Notification)
  {
    setupTouchBar()
    setupHeartRateSensor()
  }

  func applicationWillTerminate(_ aNotification: Notification)
  {
    // Insert code here to tear down your application
  }

  //MARK:- Setup

  //MARK: Touch Bar

  var statusBar : HeartRateStatusBarController? // late initialization, so VCs are ready

  func setupTouchBar()
  {
    NSApplication.shared().isAutomaticCustomizeTouchBarMenuItemEnabled = true
    statusBar = HeartRateStatusBarController()
  }

  //MARK: Heart Rate Sensing

  let heartRateSensor = FakeHeartRateSensor() //Make FakeHeartRateSensor to display fake data
  let heartRateManager = HeartRateManager()

  func setupHeartRateSensor()
  {
    heartRateSensor.maybeDelegate = heartRateManager
    heartRateSensor.connect()
  }

}

