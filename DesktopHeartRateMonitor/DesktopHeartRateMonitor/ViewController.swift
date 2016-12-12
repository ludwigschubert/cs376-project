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

  var countdownTimer: Timer?
  var currentQuestion: Question
  var currentStartTime: NSDate = NSDate.init()
  var questionSetIterator: IndexingIterator<Array<Array<Question>>> = Question.examples().makeIterator()
  var questionsIterator: IndexingIterator<Array<Question>>

  var heartRateSession: HeartRateSession = HeartRateSession.init()

  let baseLineRounds : UInt64 = 3 //will actually be this number minus 1
  let isTreatmentCondition = UserDefaults.standard.value(forKey: "conditionIndex") as! Int == 1
    let demonstrationMode = false //when demonstration mode is true it will always show the indicator

  var bucket = 1

  @IBOutlet var questionTextField: NSTextField!
  @IBOutlet var answerTextField: NSTextField!
  @IBOutlet var timerLabel: NSTextField!
  @IBOutlet weak var infoLabel: NSTextField!

  var isPaused : Bool = true {
    didSet {
      if isPaused {
        pauseUI()
      } else {
        unpauseUI()
      }
    }
  }
  var seconds = 60 {
    didSet {
      timerLabel.stringValue = "\(seconds) seconds left"
    }
  }

    @IBOutlet weak var equalSign: NSTextField!
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
    infoLabel.stringValue = "Press return to start."

  }

  func applicationWillTerminateNotification() {
    print("Received applicationWillTerminateNotification, saving…");
    heartRateSession.end()
    HeartRateSessionWriter.write(heartRateSession: heartRateSession)
  }

  override func viewWillAppear() {
    pauseUI()
  }

  //MARK: Respond to key events

  override func becomeFirstResponder() -> Bool {
    return true
  }

  override func keyDown(with event: NSEvent) {
    if event.keyCode == 36 {
      returnWasPressed()
    } else {
      nextResponder?.keyDown(with: event)
    }
  }

  //MARK:- IBActions

  func didReceiveHeartRate(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let hrInfo = userInfo["heartRateInfo"] as? HeartRateInfo,
          let average = userInfo["average"] as? Double else {
      print("didReceiveHeartRate preconditions not satisfied!!!")
      print(notification.userInfo!)
      return
    }
    globalCounter += 1
    heartRateSession.record(heartRateInfo: hrInfo);
    let chartDataEntry = ChartDataEntry(x: Double(globalCounter), y: Double(hrInfo.heartRate))
    if lineChartDataSet.addEntry(chartDataEntry) {
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
    let dBmp = Double(hrInfo.heartRate)
    let image = #imageLiteral(resourceName: "HeartRateIndicatorLight5").tinted(color: NSColor.darkGray)
    var flashImage = #imageLiteral(resourceName: "HeartRateIndicatorLight5")
    var greenImage : NSImage = #imageLiteral(resourceName: "HeartRateIndicatorLight5")
    if isTreatmentCondition {
        greenImage = #imageLiteral(resourceName: "HeartRateIndicatorLight5").tinted(color: NSColor.green)
      flashImage = flashImage.tinted(color: NSColor(red: 153.0, green: 255.0, blue: 102.0, alpha: 1.0))
          
          
//          tintedImage(#imageLiteral(resourceName: "HeartRateIndicatorLight5"), tint: )
    } else {
        greenImage = #imageLiteral(resourceName: "HeartRateIndicatorLight5").tinted(color: NSColor.red)
//        (calibratedRed: 242.0, green: 153.0, blue: 199.0, alpha:1.0))
    }
    
    imageView1.image = image
    imageView2.image = image
    imageView3.image = image
    imageView4.image = image
    imageView5.image = image
    
    
    if demonstrationMode == false {
      imageView1.isHidden = setCounter < baseLineRounds
      imageView2.isHidden = setCounter < baseLineRounds
      imageView3.isHidden = setCounter < baseLineRounds
      imageView4.isHidden = setCounter < baseLineRounds
      imageView5.isHidden = setCounter < baseLineRounds
      
    }
    //number of rounds to hide the touchbar indicator
    if demonstrationMode == true || setCounter > baseLineRounds-1 {

      
      var newBucket = 1
      if dBmp > 0.8 * average {
        self.imageView1.image = greenImage
      }
      
      if dBmp > 0.9 * average {
        newBucket = 2
        self.imageView2.image = greenImage
      }
      
      if dBmp > 1.0 * average {
        newBucket = 3
        self.imageView3.image = greenImage
      }
      
      if dBmp > 1.1 * average {
        newBucket = 4
        self.imageView4.image = greenImage
      }
      
      if dBmp > 1.2 * average {
        newBucket = 5
        self.imageView5.image = greenImage
      }
      
      if newBucket != bucket {
        NSSound(named: "Pop")?.play()
        //NSBeep()
        //later implementation can have different sound for different levels or going up vs. going down
      }
      
      let delay = 0.1
      switch newBucket {
      case 1:
        imageView1.image = flashImage
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.imageView1.image = greenImage
          
        }
      case 2:
        imageView1.image = flashImage
        imageView2.image = flashImage
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.imageView1.image = greenImage
          self.imageView2.image = greenImage
        }
      case 3:
        imageView1.image = flashImage
        imageView2.image = flashImage
        imageView3.image = flashImage
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.imageView1.image = greenImage
          self.imageView2.image = greenImage
          self.imageView3.image = greenImage
        }
      case 4:
        imageView1.image = flashImage
        imageView2.image = flashImage
        imageView3.image = flashImage
        imageView4.image = flashImage
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.imageView1.image = greenImage
          self.imageView2.image = greenImage
          self.imageView3.image = greenImage
          self.imageView4.image = greenImage
        }
      case 5:
        imageView1.image = flashImage
        imageView2.image = flashImage
        imageView3.image = flashImage
        imageView4.image = flashImage
        imageView5.image = flashImage
        
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.imageView1.image = greenImage
          self.imageView2.image = greenImage
          self.imageView3.image = greenImage
          self.imageView4.image = greenImage
          self.imageView5.image = greenImage
        }
      default:
        imageView1.image = flashImage
        let when = DispatchTime.now() + delay // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
          self.imageView1.image = greenImage
          
        }
      }
      
      bucket = newBucket
      
      
      if dBmp > 1.2 * average {
        if isTreatmentCondition {
          
          touchBarLabelString = "Alertness: SUPER HIGH"
        } else {
          touchBarLabelString = "   Stress: SUPER HIGH"
        }
      } else if dBmp > 1.1 * average {
        if isTreatmentCondition {
          touchBarLabelString = "      Alertness: HIGH"
        } else {
          touchBarLabelString = "         Stress: HIGH"
        }
      } else if dBmp > 1.0 * average {
        if isTreatmentCondition {
          touchBarLabelString = "    Alertness: NORMAL"
        } else {
          touchBarLabelString = "       Stress: NORMAL"
        }
      } else if dBmp > 0.9 * average {
        
        if isTreatmentCondition {
          touchBarLabelString = "       Alertness: LOW"
        } else {
          touchBarLabelString = "          Stress: LOW"
        }
      } else if dBmp > 0.8 * average {
        if isTreatmentCondition {
          touchBarLabelString = " Alertness: SUPER LOW"
        } else {
          touchBarLabelString = "    Stress: SUPER LOW"
        }
      }
      
    }

    

  }

  func didReceiveHeartRateStatus(notification: Notification) {
//    let userInfo = notification.userInfo!
//    let heartRateStatus = userInfo["heartRateStatus"] as! HeartRateStatus

    // LineChart Stuff
//    var color = NSColor.white
//    if setCounter >= baseLineRounds {
//        switch heartRateStatus {
//        case .Low:
//            color = NSColor.green
//            //TODO: change text and have this disappear during first 2 rounds
//            //TODO: if grey round just give heart rate
//            if isTreatmentCondition {
//                touchBarLabelString = "Heart low"
//            } else {
//                touchBarLabelString = "😴 You're not giving it your best…"
//            }
//            break
//        case .High:
//            color = NSColor.red
//            if isTreatmentCondition {
//                touchBarLabelString = "Heart rate high"
//            } else {
//                touchBarLabelString = "😎 You're getting pumped!"
//            }
//            break
//        default: //.Normal
//            touchBarLabelString = ""
//            break
//        }
//    }
    
//    lineChartDataSet.colors = [color]
//    lineChartDataSet.fillColor = color
//    lineChartView.notifyDataSetChanged()
  }

  @IBAction func submitAnswer(_ sender: Any) {
    let originalLayerColor = self.view.layer?.backgroundColor

    let answer = answerTextField.stringValue.trimmingCharacters(in: .whitespaces)
    let gotAnswerCorrect = answer == currentQuestion.answer
    let duration = -currentStartTime.timeIntervalSinceNow

    if gotAnswerCorrect {
      self.view.layer?.backgroundColor = NSColor(red:0.56, green:0.93, blue:0.56, alpha:1.0).cgColor
    } else {
      self.view.layer?.backgroundColor = NSColor(red:0.93, green:0.56, blue:0.56, alpha:1.0).cgColor
    }
    heartRateSession.record(date: Date(), duration: duration, answer: answer, correct: gotAnswerCorrect, set: Int(setCounter))

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
    guard !isPaused else {
      return
    }
    seconds -= 1
    if seconds < 0 {
      isPaused = true
    }
  }

  func endSession() {
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
    if let question = questionsIterator.next() {
      show(question: question)
    }
  }

  func pauseUI() {
    questionTextField.isHidden = true
    answerTextField.isHidden = true
    equalSign.isHidden = true
    timerLabel.isHidden = true
    infoLabel.isHidden = false
    answerTextField.resignFirstResponder()
    view.window?.makeFirstResponder(self)

    endSession()
  }

  func unpauseUI() {
    seconds = 60
    questionTextField.isHidden = false
    answerTextField.isHidden = false
    equalSign.isHidden = false
    timerLabel.isHidden = false
    infoLabel.isHidden = true
    view.window?.makeFirstResponder(answerTextField)

    startSession()
  }

  func returnWasPressed() {
    if isPaused {
      isPaused = false
    } else {
      submitAnswer(self)
    }
  }
  
  func tintedImage(_ image: NSImage, tint: NSColor) -> NSImage {
    guard let tinted = image.copy() as? NSImage else { return image }
    tinted.lockFocus()
    tint.set()
    
    let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
    NSRectFillUsingOperation(imageRect, .sourceAtop)
    
    tinted.unlockFocus()
    return tinted
  }
  


}

/*
 let tintColor = NSColor(red: 1.0, green: 0.08, blue: 0.50, alpha: 1.0)
 let image = NSImage(named: "NAME").imageWithTintColor(tintColor)
 imageView.image = image
 */

