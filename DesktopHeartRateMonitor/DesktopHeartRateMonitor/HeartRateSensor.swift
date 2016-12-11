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
  func didReceive(heartRateInfo: HeartRateInfo, sender: HeartRateSensor)
}

struct HeartRateInfo {
  let heartRate: Int
  let rr: Float
  let sensorDetected: Bool
  let energyExpended: Int?
  let date: Date
}

class HeartRateSensor: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {

  weak var maybeDelegate : HeartRateSensorDelegate?

  let heartRateServices = [CBUUID(string: "180A"), CBUUID(string: "180D")]
  let heartRateCharacteristicUUID = CBUUID(string: "2A37")
  let heartRateSensorName = "Polar H7 BF6E1117"

  var centralManager : CBCentralManager?
  var peripheral: CBPeripheral?
  
  private enum HeartRateMeasurement: UInt8 {
    case HeartRateValueFormatUInt8  = 0b00000000
    case HeartRateValueFormatUInt16 = 0b00000001
    case SensorContactIsSupported   = 0b00000100
    case SensorContactDetected      = 0b00000110
    case EnergyExpended             = 0b00001000
    case RRInterval                 = 0b00010000
    
    func flagIsSet(flagData: UInt8) -> Bool {
      return (flagData & self.rawValue) != 0
    }
  }
  
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
    guard let delegate = maybeDelegate else {
      return
    }
    if characteristic.uuid == heartRateCharacteristicUUID {
      if let hrmData = characteristic.value {
        
        var heartRate = 0
        var sensorDetected = false
        var energyExpended : Int?
        var rrIntervals = [Float]()
        
        var byteIndex = hrmData.startIndex // index into the measurement data of the next byte to read
        
        let hrmFlags = [UInt8](hrmData).first!
        byteIndex += MemoryLayout<UInt8>.size
        
        if HeartRateMeasurement.HeartRateValueFormatUInt16.flagIsSet(flagData: hrmFlags) {
          var value: UInt16 = 0
          value = (UInt16(hrmData[byteIndex+1]) << 8) + UInt16(hrmData[byteIndex])
          byteIndex += MemoryLayout<UInt16>.size
          heartRate = Int(value)
        } else {
          var value: UInt8 = 0
          value = hrmData[byteIndex]
          byteIndex += MemoryLayout<UInt8>.size
          heartRate = Int(value)
        }
        
        if HeartRateMeasurement.SensorContactIsSupported.flagIsSet(flagData: hrmFlags) {
          sensorDetected = HeartRateMeasurement.SensorContactDetected.flagIsSet(flagData: hrmFlags)
        }
        
        if HeartRateMeasurement.EnergyExpended.flagIsSet(flagData: hrmFlags) {
          var value: UInt16 = 0
          value = (UInt16(hrmData[byteIndex+1]) << 8) + UInt16(hrmData[byteIndex])
          byteIndex += MemoryLayout<UInt16>.size
          energyExpended = Int(value)
        }
        
        if HeartRateMeasurement.RRInterval.flagIsSet(flagData: hrmFlags) {
          while byteIndex < hrmData.count {
            var value: UInt16 = 0
            value = (UInt16(hrmData[byteIndex+1]) << 8) + UInt16(hrmData[byteIndex])
            byteIndex += MemoryLayout<UInt16>.size
            rrIntervals.append(Float(value) / 1024.0)
          }
        }

        let heartRateInfo = HeartRateInfo(heartRate: heartRate,
                                          rr: rrIntervals.average,
                                          sensorDetected: sensorDetected,
                                          energyExpended: energyExpended,
                                          date: Date())

        delegate.didReceive(heartRateInfo: heartRateInfo, sender: self);

      }
    }
  }

}
