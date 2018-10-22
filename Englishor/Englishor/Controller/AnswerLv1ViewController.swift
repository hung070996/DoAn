//
//  AnswerLv1ViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import CountdownLabel
import SwiftyButton
import Speech
import AVFoundation
import AMPopTip
import UITextField_Shake

class AnswerLv1ViewController: UIViewController {

    @IBOutlet weak var true2: UIImageView!
    @IBOutlet weak var true1: UIImageView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var submitButton: PressableButton!
    @IBOutlet weak var meaningTextfield: UITextField!
    @IBOutlet weak var wordLabel: LTMorphingLabel!
    @IBOutlet weak var countdownView: CountdownView!
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var timeCountdown: Double = 3
    var words = [Word]()
    private var index = -1
    private var total: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        words = getRandom(in: words, quantity: words.count)
        wordLabel.morphingEffect = .burn
        setupPressableButton(color: .red, shadow: .lightGray, button: submitButton)
        nextWord()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownView.start(time: timeCountdown) { [unowned self] in
            if self.index < self.words.count {
                self.pushToLv2()
            }
        }
    }
    
    func pushToLv2() {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv2ViewController") as? Lv2ViewController
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func trueAnswer() {
        total += 100 / 2 / Double(Phase.shared.difficulty.numberOfQuestion)
    }
    
    func nextWord() {
        index += 1
        if index < words.count {
            wordLabel.text = words[index].word
            true1.isHidden = true
            true2.isHidden = true
            self.meaningTextfield.isEnabled = false
            self.meaningTextfield.text = ""
        } else {
            pushToLv2()
        }
    }
    
    @IBAction func clickLoud(_ sender: UIButton) {
        if audioEngine.isRunning {
            microphoneButton.setImage(UIImage(named: "micro"), for: .normal)
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            startRecording()
        }
    }
    
    func startRecording() {
        let filePath = Bundle.main.path(forResource: "micro_active", ofType: "gif")
        let gifData = NSData(contentsOfFile: filePath ?? "") as Data?
        microphoneButton.setImage(UIImage.sd_animatedGIF(with: gifData), for: .normal)
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()  
        do {
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: [.defaultToSpeaker])
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?
            .recognitionTask(with: recognitionRequest,
                             resultHandler: { [weak self] (result, error) in
                                guard let `self` = self, let result = result else { return }
                                self.microphoneButton.setImage(UIImage(named: "micro"), for: .normal)
                                self.audioEngine.stop()
                                recognitionRequest.endAudio()
                                if result.isFinal {
                                    let resultText = result.bestTranscription.formattedString
                                    if compare(resultText, self.words[self.index].word) {
                                        self.true1.isHidden = false
                                        self.meaningTextfield.isEnabled = true
                                        self.trueAnswer()
                                    } else {
                                        let popTip = PopTip()
                                        popTip.shouldDismissOnTap = true
                                        popTip.show(text: resultText,
                                                    direction: .right,
                                                    maxWidth: 200,
                                                    in: self.view,
                                                    from: self.microphoneButton.frame,
                                                    duration: 2)
//                                        inputNode.removeTap(onBus: 0)
//                                        self.startRecording()
                                    }
                                }
            
                                if error != nil || result.isFinal {
                                    self.microphoneButton.setImage(UIImage(named: "micro"), for: .normal)
                                    self.audioEngine.stop()
                                    inputNode.removeTap(onBus: 0)
                                    self.recognitionRequest = nil
                                    self.recognitionTask = nil
                                    
                                }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }

    @IBAction func clickSubmit(_ sender: Any) {
        if compare(meaningTextfield.text ?? "", words[index].meaning) {
            trueAnswer()
            true2.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
                guard let `self` = self else { return }
                self.nextWord()
            }
        } else {
            meaningTextfield.shake()
        }
    }
}

