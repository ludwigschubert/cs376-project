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
  var setCounter : UInt64 = 0
  var seconds = 60
  var countdownTimer: Timer?
  var currentQuestion: Question
  var currentStartTime: NSDate = NSDate.init()
  var questionSetIterator: IndexingIterator<Array<Array<Question>>> = Question.examples().makeIterator()
  var questionsIterator: IndexingIterator<Array<Question>>

  var heartRateSession: HeartRateSession = HeartRateSession.init()

  @IBOutlet var questionTextField: NSTextField!
  @IBOutlet var answerTextField: NSTextField!
  @IBOutlet var timerLabel: NSTextField!

  required init?(coder: NSCoder) {
    let questionSet = questionSetIterator.next()!
    questionsIterator = questionSet.makeIterator()
    currentQuestion = questionsIterator.next()!
    super.init(coder: coder)
  }

  // TouchBar Extensions
  let lineChartView = LineChartView.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
  let imageView1 = NSImageView()
  let imageView2 = NSImageView()
  let imageView3 = NSImageView()
  let imageView4 = NSImageView()
  let imageView5 = NSImageView()
  dynamic var touchBarLabelString = ""

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
    //        answerTextField.isAutomaticTextCompletionEnabled = false
    countdownTimer = Timer.init(timeInterval: 1.0, target: self, selector: #selector(ViewController.timerWasFired), userInfo: nil, repeats: true)
    RunLoop.current.add(countdownTimer!, forMode: RunLoopMode.commonModes)

    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveHeartRate),
                                           name: Notification.Name.receivedHeartRate, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(ViewController.didReceiveHeartRateStatus),
                                           name: Notification.Name.heartRateStatusChanged, object: nil)

//    print(UserDefaults.standard.value(forKey: "participantName"))
    timerLabel.stringValue = "\(seconds) seconds left"

  }

  func applicationWillTerminateNotification() {
    print("Received applicationWillTerminateNotification, saving…");
    heartRateSession.end()
    HeartRateSessionWriter.write(heartRateSession: heartRateSession)
  }

  override func viewWillAppear() {
    if let question = questionsIterator.next() {
      show(question: question)
    }
  }

  //MARK:- IBActions

  func didReceiveHeartRate(notification: Notification) {
    globalCounter += 1
    let userInfo = notification.userInfo!
    let bpm = userInfo["bpm"] as! Int
//    touchBarLabelString = "\(bpm) bpm"
    let average = userInfo["average"] as! Double
    heartRateSession.record(bpmValue: bpm);
    let chartDataEntry = ChartDataEntry(x: Double(globalCounter), y: Double(bpm))
    let addedSuccessfully = lineChartDataSet.addEntry(chartDataEntry)
    if addedSuccessfully {
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

    // Indicator Lights Stuff
    let dBmp = Double(bpm)
    let image = #imageLiteral(resourceName: "HeartRateIndicatorLight5").tinted(color: NSColor.darkGray)
    var greenImage : NSImage
    if UserDefaults.standard.value(forKey: "conditionIndex") as! Int == 1 && setCounter >= 2 {
        greenImage = #imageLiteral(resourceName: "HeartRateIndicatorLight5").tinted(color: NSColor.green)
    } else {
        greenImage = #imageLiteral(resourceName: "HeartRateIndicatorLight5")
    }
    
    imageView1.image = image
    imageView2.image = image
    imageView3.image = image
    imageView4.image = image
    imageView5.image = image
    
    //number of rounds to hide the touchbar indicator
    imageView1.isHidden = setCounter < 2
    imageView2.isHidden = setCounter < 2
    imageView3.isHidden = setCounter < 2
    imageView4.isHidden = setCounter < 2
    imageView5.isHidden = setCounter < 2


    
    if dBmp > 0.8 * average {
      imageView1.image = greenImage
    }

    if dBmp > 0.9 * average {
      imageView2.image = greenImage
    }

    if dBmp > 1.0 * average {
      imageView3.image = greenImage
    }

    if dBmp > 1.1 * average {
      imageView4.image = greenImage
    }

    if dBmp > 1.2 * average {
      imageView5.image = greenImage
    }

  }

  func didReceiveHeartRateStatus(notification: Notification) {
    let userInfo = notification.userInfo!
    let heartRateStatus = userInfo["heartRateStatus"] as! HeartRateStatus

    // LineChart Stuff
    var color = NSColor.white
    switch heartRateStatus {
    case .Low:
      color = NSColor.green
      //TODO: change text and have this disappear during first 2 rounds
      //TODO: if grey round just give heart rate
      touchBarLabelString = "😴 You're not giving it your best…"
      break
    case .High:
      color = NSColor.red
      touchBarLabelString = "😎 You're getting pumped!"
      break
    default: //.Normal
      touchBarLabelString = ""
      break
    }
    lineChartDataSet.colors = [color]
    lineChartDataSet.fillColor = color
    lineChartView.notifyDataSetChanged()
  }

  @IBAction func submitAnswer(_ sender: Any) {
    print("Submit pressed!")

    let originalLayerColor = self.view.layer?.backgroundColor

    let answer = answerTextField.stringValue.trimmingCharacters(in: .whitespaces)
    let gotAnswerCorrect = answer == currentQuestion.answer
    let timeInterval = currentStartTime.timeIntervalSinceNow

    if gotAnswerCorrect {
      self.view.layer?.backgroundColor = NSColor(red:0.56, green:0.93, blue:0.56, alpha:1.0).cgColor
    } else {
      self.view.layer?.backgroundColor = NSColor(red:0.93, green:0.56, blue:0.56, alpha:1.0).cgColor
    }
    heartRateSession.record(gotAnswerCorrect: gotAnswerCorrect, afterTimeInterval: timeInterval)

    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1),
                                  execute: {
                                    self.view.layer?.backgroundColor = originalLayerColor;
                                    if !self.answerTextField.isHidden {
                                      if let question = self.questionsIterator.next() {
                                        if gotAnswerCorrect {
                                          self.show(question: question)
                                        }
                                      } else {
                                        print("You should not get to the end")
                                      }
                                    }
    })

  }

  @IBAction func saveButtonWasPressed(_ sender: NSButtonCell)
  {
//    heartRateSession.participantName = participantNameTextField.stringValue
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
    answerTextField?.stringValue = ""
    currentStartTime = NSDate.init()
  }

  func timerWasFired() {
    seconds -= 1
    if seconds < 0 {
      if answerTextField.isHidden { // we're in a pause, need to start
        seconds = 60
        startSession()
      } else { // we're in a session, need to pause
        seconds = 30
        endSession()
      }
    }
    timerLabel.stringValue = "\(seconds) seconds left"
  }

  func endSession() {
    questionTextField.isHidden = true
    answerTextField.isHidden = true

    if let questionSet = questionSetIterator.next() {
      setCounter += 1
      questionsIterator = questionSet.makeIterator()
    } else {
      timerLabel.isHidden = true
      print("End of last session")
      self.view.window?.close()
    }
  }

  func startSession() {
    questionTextField.isHidden = false
    answerTextField.isHidden = false

    if let question = questionsIterator.next() {
      show(question: question)
    }
  }


}

