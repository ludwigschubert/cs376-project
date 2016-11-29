//
//  HeartRateSensor.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 11/6/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol HeartRateSensorDelegate: class {
    func didReceive(bpm: Int, sender: HeartRateSensor)
}

class HeartRateSensor: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

    weak var delegate:HeartRateSensorDelegate?

    let heartRateServices = [CBUUID(string: "180A"), CBUUID(string: "180D")]
    let heartRateCharacteristicUUID = CBUUID(string: "2A37")
    let heartRateSensorName = "Polar H7 BF6E1117"

    var centralManager : CBCentralManager?
    var peripheral: CBPeripheral?

    func connect() {
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }

    //MARK:- CoreBluetooth Manager Delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        if (central.state == CBCentralManagerState.poweredOn) {
            print("Bluetooth is powered on!")
            central.scanForPeripherals(withServices: heartRateServices, options: nil)
        } else {
            print("CBCentralManagerState not powered on?")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] as! String? {
            print("Discovered: " + name)
            if name == heartRateSensorName {
                central.stopScan()
                central.connect(peripheral)
                self.peripheral = peripheral
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected:", peripheral.name!)

        self.peripheral!.delegate = self
        self.peripheral!.discoverServices(heartRateServices);
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to Connect: ", peripheral)

        central.scanForPeripherals(withServices: heartRateServices, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected: ", peripheral)
//        bpmLabel.stringValue = "Disconnected from \(peripheral.name!), retrying…"
        central.scanForPeripherals(withServices: heartRateServices, options: nil)
    }

    //MARK:- CoreBluetooth Peripheral Delegate

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        for service:CBService in peripheral.services! {
            print("Discovered service: \(service.uuid.uuidString)")

            peripheral.discoverCharacteristics(nil, for: service)
        }
    }


    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?)
    {
        for characteristic:CBCharacteristic in service.characteristics! {
            if characteristic.uuid == heartRateCharacteristicUUID {
                peripheral.setNotifyValue(true, for: characteristic)
//                bpmLabel.stringValue = "Gathering Heart Rate…"
                print("Subscribed to heart rate!\n")
            }
        }
    }


    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if characteristic.uuid == heartRateCharacteristicUUID {
            if let rate = characteristic.value {

                var buffer = [UInt8](repeating: 0x00, count: rate.count)
                rate.copyBytes(to: &buffer, count: buffer.count)

                var bpm:UInt16?
                if (buffer.count >= 2){
                    if (buffer[0] & 0x01 == 0) {
                        bpm = UInt16(buffer[1]);
                    } else {
                        bpm = UInt16(buffer[1]) << 8
                        bpm =  bpm! | UInt16(buffer[2])
                    }
                }

                if let aBpm = bpm {
//                    print("Received Heart Rate: \(aBpm) Bpm")
                    if let aDelegate = delegate {
                        aDelegate.didReceive(bpm: Int(aBpm), sender: self);
                    }
                }
            }
        }
    }

}
