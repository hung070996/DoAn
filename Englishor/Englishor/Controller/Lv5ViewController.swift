//
//  Lv5ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import ApiAI
import SQLite

class Lv5ViewController: UIViewController {

    @IBOutlet weak var navigationView: NavigationView!
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var microphoneButton: UIButton!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var timeCountdown: Double = Phase.shared.difficulty.timeOfConversation
    private var totalPoint: Double = 0
    private var conversation = [String]()
    private var isPushed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
        navigationView.setHiddenView(nextLv: false, title: false, back: true)
        navigationView.setTitle(title: "Lv5")
        navigationView.delegate = self
        
        let request = ApiAI.shared().textRequest()
        guard let name = Phase.shared.topic?.name else { return }
        request?.query = "Ask me about " + name
        request?.setMappedCompletionBlockSuccess({ [weak self] (request, response) in
            guard let `self` = self else { return }
            guard let response = response as? AIResponse else { return }
            if let textResponse = response.result.fulfillment.speech {
                Utils.shared.speechAndText(text: textResponse)
                self.conversation.append(textResponse)
                
                self.tableView.reloadData()
                self.scrollToBottom()
            }
            }, failure: { (request, error) in
                print(error!)
        })
        ApiAI.shared().enqueue(request)
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
            self.pushToResult()
        }
    }
    
    func pushToResult() {
        let phase = Phase.shared
        let table = Table("Phase")
        let date = Expression<String>("date")
        let pointLv1 = Expression<Int>("pointLv1")
        let pointLv2 = Expression<Int>("pointLv2")
        let pointLv3 = Expression<Int>("pointLv3")
        let pointLv4 = Expression<Int>("pointLv4")
        let pointLv5 = Expression<Int>("pointLv5")
        let idTopic = Expression<Int>("idTopic")
        let idDifficulty = Expression<Int>("idDifficulty")

        if !isPushed {
            
            Phase.shared.pointLv5 = Int(totalPoint)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let today = formatter.string(from: Date())
            
            Phase.shared.date = today
            do {
                var check = false
                for row in try DatabaseManager.shared.connection!.prepare(table) {
                    if row[date] == today {
                        check = true
                        break
                    }
                }
                
                if !check {
                    let insert = table.insert(date <- phase.date ?? "",
                                              pointLv1 <- phase.pointLv1 ?? 0,
                                              pointLv2 <- phase.pointLv2 ?? 0,
                                              pointLv3 <- phase.pointLv3 ?? 0,
                                              pointLv4 <- phase.pointLv4 ?? 0,
                                              pointLv5 <- phase.pointLv5 ?? 0,
                                              idTopic <- phase.topic.id,
                                              idDifficulty <- phase.difficulty.id)
                    try DatabaseManager.shared.connection!.run(insert)
                }
            } catch {
                
            }
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController
            navigationController?.pushViewController(vc!, animated: true)
            isPushed = true
        }
    }
    
    @IBAction func clickRecord(_ sender: Any) {
        if audioEngine.isRunning {
            microphoneButton.setImage(UIImage(named: "micro"), for: .normal)
            audioEngine.stop()
            recognitionRequest?.endAudio()
        } else {
            startRecording()
        }
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.conversation.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
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
            try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: [])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
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
                                    self.scrollToBottom()
                                    let request = ApiAI.shared().textRequest()
                                    request?.query = resultText
                                    request?.setMappedCompletionBlockSuccess({ [weak self] (request, response) in
                                        guard let `self` = self else { return }
                                        guard let response = response as? AIResponse else { return }
                                        if let textResponse = response.result.fulfillment.speech {
                                            Utils.shared.speechAndText(text: textResponse)
                                            self.conversation.append(textResponse)
                                            self.totalPoint += 10
                                            if self.totalPoint > 100 {
                                                self.totalPoint = 100
                                            }
                                            self.tableView.reloadData()
                                            self.scrollToBottom()
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

extension Lv5ViewController: NavigationViewDelegate {
    func clickNext() {
        pushToResult()
    }
}

extension Lv5ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell: LeftChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.label.text = conversation[indexPath.row]
            return cell
        } else {
            let cell: RightChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.label.text = conversation[indexPath.row]
            return cell
        }
    }
}
