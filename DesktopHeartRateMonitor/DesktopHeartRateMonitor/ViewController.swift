//
//  ViewController.swift
//  DesktopHeartRateMonitor
//
//  Created by Ludwig Schubert on 10/30/16.
//  Copyright © 2016 Ludwig Schubert. All rights reserved.
//

import Cocoa
import Charts

class ViewController: NSViewController {

    let lineChartData = LineChartData()
    let lineChartDataSet = LineChartDataSet(values: [ChartDataEntry(x: 1.0, y: 1.0)], label: "Heart Rate (bpm)")
    
    var globalCounter : UInt64 = 0
    var seconds = 0
    var secondTimer: Timer?
    var currentQuestion: Question?
    var currentStartTime: NSDate?
    var questionsIterator: IndexingIterator<Array<Question>>?

    var heartRateSession: HeartRateSession = HeartRateSession.init()

    @IBOutlet var bpmLabel: NSTextField!
    @IBOutlet var participantNameTextField: NSTextField!
    let lineChartView = LineChartView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    @IBOutlet var questionLabel: NSTextField!
    @IBOutlet var questionTextField: NSTextField!
    @IBOutlet var answerLabel: NSTextField!
    @IBOutlet var answerTextView: NSTextView!
    @IBOutlet var timerLabel: NSTextField!

    // TouchBar Extensions
//    let images = [NSImage(named: "AppIcon"), NSImage(named: "StatusBarIcon")]
//    dynamic var image : NSImage?
//    var count = 0

    //MARK:- NSViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationWillTerminateNotification), name: NSNotification.Name.NSApplicationWillTerminate, object: nil)

        // Set up Chart
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.chartDescription?.enabled = false
        lineChartView.gridBackgroundColor = NSColor.controlColor
        lineChartView.drawGridBackgroundEnabled = true
        lineChartView.xAxis.enabled = false
        lineChartView.leftAxis.enabled = false
        lineChartView.rightAxis.enabled = false
        lineChartView.xAxis.drawLabelsEnabled = false
        lineChartView.legend.enabled = false
        lineChartView.maxVisibleCount = 10
        lineChartView.minOffset = 0.0
//        lineChartView.leftAxis.axisMinimum = 60.0
//        lineChartView.leftAxis.axisMaximum = 130.0

        lineChartDataSet.colors = [NSUIColor.white]
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.mode = Charts.LineChartDataSet.Mode.cubicBezier
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.fillColor = NSUIColor.white
        lineChartData.addDataSet(lineChartDataSet);
        lineChartView.data = lineChartData

        // Set up Question
//        answerTextView.isAutomaticTextCompletionEnabled = false
        questionsIterator = Question.examples().makeIterator()
        secondTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(ViewController.timerWasFired), userInfo: nil, repeats: true)
        RunLoop.current.add(secondTimer!, forMode: RunLoopMode.commonModes)

        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveHeartRate),
        name: Notification.Name.receivedHeartRate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveHeartRateStatus),
                                               name: Notification.Name.heartRateStatusChanged, object: nil)

        // TouchBar Extensions
//        self.image = self.images[0]
//        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { timer in
//            self.count += 1
//            self.image = self.images[self.count % 2]
//        }

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

    //MARK:- IBActions

    func didReceiveHeartRate(notification: Notification) {
        globalCounter += 1
        let userInfo = notification.userInfo!
        let bpm = userInfo["bpm"] as! Int
        bpmLabel.stringValue = "\(bpm) bpm"
        heartRateSession.record(bpmValue: bpm);
        let chartDataEntry = ChartDataEntry(x: Double(globalCounter), y: Double(bpm))
        let addedSuccessfully = lineChartDataSet.addEntry(chartDataEntry)
        if addedSuccessfully {
            print(lineChartDataSet.entryCount)
            if lineChartDataSet.entryCount > 11 {
                let removedSuccesfully = lineChartDataSet.removeFirst()
                if !removedSuccesfully {
                    print("WTF")
                }
            }
        }
        lineChartData.notifyDataChanged()
        lineChartView.notifyDataSetChanged()

        lineChartView.layer?.cornerRadius = 6;
        lineChartView.layer?.masksToBounds = true;
    }
    
    func didReceiveHeartRateStatus(notification: Notification) {
        let userInfo = notification.userInfo!
        let heartRateStatus = userInfo["heartRateStatus"] as! HeartRateStatus
        var color = NSColor.white
        switch heartRateStatus {
        case .Low:
            color = NSColor.green
            break
        case .High:
            color = NSColor.red
            break
        default: //.Normal
            break
        }
        lineChartDataSet.colors = [color]
        lineChartDataSet.fillColor = color
//        lineChartData.notifyDataChanged()
        lineChartView.notifyDataSetChanged()
    }

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
                                            if gotAnswerCorrect {
                                                self.show(question: question)
                                            }
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
        answerTextView?.string = ""
        currentStartTime = NSDate.init()
    }

    func timerWasFired() {
        seconds += 1
        timerLabel.stringValue = "\(seconds)s"
    }


}

