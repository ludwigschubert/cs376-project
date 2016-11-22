//
//  FakeHeartRateSensor.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 11/21/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation

class FakeHeartRateSensor : HeartRateSensor {

    private var timer : Timer?
    private var count = 0
    private let countBeforeHighRate = 30

    override init() {
        super.init()
        timer = Timer(timeInterval: 1.2,
                      target: self,
                      selector: #selector(FakeHeartRateSensor.fakeHeartBeat),
                      userInfo: nil,
                      repeats: true)
    }

    override func connect() {
        RunLoop.main.add(timer!, forMode: .defaultRunLoopMode)
    }

    func fakeHeartBeat() {
        count += 1
        var µ : Double
        if count > countBeforeHighRate {
            µ = 120.0
        } else {
            µ = 80.0
        }
        let fakeHeartRate = gaussian(µ: µ, σ: 8.0) // 8.0 is cutoff for calibration, so should eventually succeed
        if let aDelegate = delegate {
//            print("fake heart rate: ", fakeHeartRate)
            aDelegate.didReceive(bpm: Int(fakeHeartRate), sender: self);
        }
    }

    private func gaussian(µ: Double, σ: Double) -> Double {
        //Box-Muller transformation; polar form for numerical stability
        var x1 : Double
        var x2 : Double
        var w  : Double
        var y1 : Double

        repeat {
            x1 = 2.0 * drand48() - 1.0;
            x2 = 2.0 * drand48() - 1.0;
            w = x1 * x1 + x2 * x2;
        } while ( w >= 1.0 );

        w = sqrt( (-2.0 * log( w ) ) / w );
        y1 = x1 * w;

        return y1 * σ + µ
    }

}
