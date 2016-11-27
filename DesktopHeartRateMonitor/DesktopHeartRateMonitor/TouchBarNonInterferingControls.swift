//
//  TextView.swift
//  DesktopHeartRateMonitor
//
//  Created by Dovid Kahn on 11/22/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Cocoa


extension NSTextView {
    
    @available(OSX 10.12.1, *)
    override open func makeTouchBar() -> NSTouchBar? {
        return nil
    }
}
