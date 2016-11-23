//
//  WindowController.swift
//  DesktopHeartRateMonitor
//
//  Created by Dovid Kahn on 11/22/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
    
//    override func windowDidLoad() {
//        super.windowDidLoad()
//    }
    
    override func makeTouchBar() -> NSTouchBar? {
        guard let viewController = contentViewController as? ViewController else {
            return nil
        }
        return viewController.makeTouchBar()
    }
    
}


