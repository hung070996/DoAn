//
//  Lv4ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/22/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import ApiAI
import AMPopTip

class Lv4ViewController: UIViewController {
    
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var navigationView: NavigationView!
    
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var timeCountdown: Double = Phase.shared.difficulty.timeOfConversation
    private var totalPoint: Double = 70
    private var conversation = [String]()
    private var isPushed = false
    private let popTip = PopTip()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        navigationView.setHiddenView(nextLv: false, title: false, back: true)
        navigationView.setTitle(title: "Lv4")
        navigationView.delegate = self
        popTip.shouldDismissOnTap = true
        popTip.font = UIFont(name: "Chalkboard SE", size: 20)!
        popTip.show(text: "Say Hi to start", direction: .right, maxWidth: 200.0, in: view, from: microphoneButton.frame)
    }
    
    func configTable() {
        tableView.register(cellType: LeftChatCell.self)
        tableView.register(cellType: RightChatCell.self)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countdownView.start(time: timeCountdown) { [unowned self] in
            self.pushToLv5()
        }
    }

    func pushToLv5() {
        if !isPushed {
            Phase.shared.pointLv4 = Int(totalPoint)
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv5ViewController") as? Lv5ViewController
            navigationController?.pushViewController(vc!, animated: true)
            isPushed = true
        }
    }
    
    @IBAction func clickRecord(_ sender: Any) {
        popTip.hide()
        if audioEngine.isRunning {
            microphoneButton.setImage(UIImage(named: "micro"), for: .normal)
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            startRecording()
        }
    }
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
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
        inputNode.removeTap(onBus: 0)
        
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
                                    self.conversation.append(resultText)
                                    self.tableView.reloadData()
                                    let request = ApiAI.shared().textRequest()
                                    request?.query = resultText
                                    request?.setMappedCompletionBlockSuccess({ [weak self] (request, response) in
                                        guard let `self` = self else { return }
                                        guard let response = response as? AIResponse else { return }
                                        if let textResponse = response.result.fulfillment.speech {
                                            self.conversation.append(textResponse)
                                            self.tableView.reloadData()
                                            self.speechAndText(text: textResponse)
                                        }
                                    }, failure: { (request, error) in
                                        print(error!)
                                    })
                                    ApiAI.shared().enqueue(request)
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
}

extension Lv4ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell: LeftChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.avatar.image = UIImage(named: "microphone")
            cell.label.text = conversation[indexPath.row]
            return cell
        } else {
            let cell: RightChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.avatar.image = UIImage(named: "micro")
            cell.label.text = conversation[indexPath.row]
            return cell
        }
        
    }
}

extension Lv4ViewController: NavigationViewDelegate {
    func clickNext() {
        pushToLv5()
    }
}
