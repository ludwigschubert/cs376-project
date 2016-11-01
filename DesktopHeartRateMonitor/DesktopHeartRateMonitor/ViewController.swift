//
//  ViewController.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 10/30/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Cocoa
import CoreBluetooth
import Charts

class ViewController: NSViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    let heartRateServices = [CBUUID.init(string: "180A"), CBUUID.init(string: "180D")]
    let heartRateCharacteristicUUID = CBUUID(string: "2A37")
    let lineChartData = LineChartData()
    let lineChartDataSet = LineChartDataSet(values: [ChartDataEntry(x: 1.0, y: 1.0)], label: "Heart Rate (bpm)")

    var seconds = 0
    var secondTimer: Timer?
    var currentQuestion: Question?
    var currentStartTime: NSDate?
    var questionsIterator: IndexingIterator<Array<Question>>?

    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    var heartRateSession: HeartRateSession = HeartRateSession.init()

    @IBOutlet weak var bpmLabel: NSTextField!
    @IBOutlet weak var participantNameTextField: NSTextField!
    @IBOutlet weak var lineChartView: LineChartView!
    @IBOutlet weak var questionLabel: NSTextField!
    @IBOutlet weak var questionTextField: NSTextField!
    @IBOutlet weak var answerLabel: NSTextField!
    @IBOutlet weak var answerTextView: NSTextView!
    @IBOutlet weak var timerLabel: NSTextField!
    
    //MARK:- NSViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()


        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationWillTerminateNotification), name: NSNotification.Name.NSApplicationWillTerminate, object: nil)

        // Set up Chart
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.chartDescription?.text = ""
        lineChartView.gridBackgroundColor = NSUIColor.white
        lineChartView.xAxis.drawLabelsEnabled = false

        lineChartDataSet.colors = [NSUIColor.red]
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.mode = Charts.LineChartDataSet.Mode.cubicBezier
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.fillColor = NSUIColor.red
        lineChartData.addDataSet(lineChartDataSet);
        lineChartView.data = lineChartData

        // Set up Question
        questionsIterator = Question.examples().makeIterator()
        secondTimer = Timer.init(timeInterval: 1.0, repeats: true, block: {
            _ in self.timerWasFired()
        })
        RunLoop.current.add(secondTimer!, forMode: RunLoopMode.commonModes)

    }

    func applicationWillTerminateNotification() {
        print("Received applicationWillTerminateNotification, saving…");
        heartRateSession.end()
        HeartRateSessionWriter.write(heartRateSession: heartRateSession)
    }

    override func viewWillAppear() {
        if let question = questionsIterator!.next() {
            show(question: question)
        }
    }

    //MARK:- CoreBluetooth Manager Delegate
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        if (central.state == CBCentralManagerState.poweredOn) {
            print("Bluetooth is powered on!")
            self.centralManager?.scanForPeripherals(withServices: heartRateServices, options: nil)
        } else {
            print("CBCentralManagerState not powered on?")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = advertisementData[CBAdvertisementDataLocalNameKey] {
            print("Discovered: " + (name as! String))
            bpmLabel.stringValue = "Connecting to \(peripheral.name!)…"
            central.stopScan()
            central.connect(peripheral)
            self.peripheral = peripheral
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
        bpmLabel.stringValue = "Disconnected from \(peripheral.name!), retrying…"
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
                bpmLabel.stringValue = "Gathering Heart Rate…"
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

                if let actualBpm = bpm {
                    //print("Received Heart Rate: \(actualBpm) Bpm")
                    bpmLabel.stringValue = "\(actualBpm) bpm"
                    heartRateSession.record(bpmValue: Int(actualBpm));
                    let chartDataEntry = ChartDataEntry(x: Double(lineChartDataSet.entryCount), y: Double(actualBpm))
                    let _ = lineChartDataSet.addEntry(chartDataEntry)
                    lineChartData.notifyDataChanged()
                    lineChartView.notifyDataSetChanged()
                }
            }
        }
    }

    //MARK:- IBActions

    @IBAction func submitButtonWasPressed(_ sender: NSButton)
    {
        let originalColor = self.answerTextView.backgroundColor

        let answer = answerTextView.string?.trimmingCharacters(in: .whitespaces)
        let gotAnswerCorrect = answer == currentQuestion?.answer
        let timeInterval = currentStartTime!.timeIntervalSinceNow
        if gotAnswerCorrect {
            self.answerTextView.backgroundColor = NSColor.green
        } else {
            self.answerTextView.backgroundColor = NSColor.red
        }
        heartRateSession.record(gotAnswerCorrect: gotAnswerCorrect, afterTimeInterval: timeInterval)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3),
                                      execute: {
                                        self.answerTextView.backgroundColor = originalColor

                                        if let question = self.questionsIterator!.next() {
                                            self.show(question: question)
                                        } else {
                                            // show end
                                        }
        })

    }

    @IBAction func saveButtonWasPressed(_ sender: NSButtonCell)
    {
        heartRateSession.participantName = participantNameTextField.stringValue
        heartRateSession.end()
        HeartRateSessionWriter.write(heartRateSession: heartRateSession)
        self.heartRateSession = HeartRateSession.init()
        lineChartDataSet.values = [];
        lineChartData.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
    }

    //MARK:- Internal

    func show(question: Question) {
        currentQuestion = question
        questionTextField.stringValue = question.text
        answerTextView.string = ""
        currentStartTime = NSDate.init()
    }

    func timerWasFired() {
        seconds += 1
        timerLabel.stringValue = "\(seconds)s"
    }


}

