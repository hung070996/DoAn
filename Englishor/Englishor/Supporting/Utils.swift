//
//  Global.swift
//  Englishor
//
//  Created by do.tien.hung on 10/17/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit
import SwiftyButton
import AVFoundation
import UserNotifications

class Utils {
    static let shared = Utils()
    private init() {}
    
    let globalFont = UIFont(name: "Chalkboard SE", size: 20)!
    let speechSynthesizer = AVSpeechSynthesizer()
    var player: AVAudioPlayer?
    let synonyms = [
        "like": ["love", "would like", "prefer"],
        "lovely": ["cute"]
    ]
    
    func standardSentence (sentence: String) -> String {
        var temp = sentence
        for item in synonyms {
            for value in item.value {
                if temp.contains(value) {
                    temp = temp.replacingOccurrences(of: value, with: item.key)
                }
            }
        }
        return temp
    }
    
    func endRecord() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.soloAmbient, mode: AVAudioSession.Mode.spokenAudio, options: [])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
    }
    
    func playSound(correct: Bool) {
        endRecord()
        let string = correct ? "correct.mp3" : "wrong.mp3"
        let path = Bundle.main.path(forResource: string, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            
        }
    }
    
    func setupPressableButton(color: UIColor?, shadow: UIColor?, button: PressableButton) {
        if let color = color, let shadow = shadow {
            button.colors = .init(button: color, shadow: shadow)
        }
        button.shadowHeight = 6
        button.cornerRadius = 10
        button.depth = 0.5
    }
    
    func speechAndText(text: String) {
        endRecord()
        let speechUtterance = AVSpeechUtterance(string: text)
        speechSynthesizer.speak(speechUtterance)
    }
    
    func getRandom<T>(in array: [T], quantity: Int) -> [T] {
        var result = [T]()
        var temp = array
        if quantity <= array.count {
            for _ in 0..<quantity {
                let random = Int.random(in: 0..<temp.count)
                result.append(temp[random])
                temp.remove(at: random)
            }
        }
        return result
    }
    
    func compare(_ string1: String, _ string2: String) -> Bool {
        return string1.lowercased() == string2.lowercased()
    }
    
    func getDataAnalytic() -> [Phase] {
        if UserDefaults.standard.object(forKey: "data") == nil {
            return []
        } else {
            let decoded  = UserDefaults.standard.object(forKey: "data") as! Data
            let decodedData = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Phase]
            return decodedData
        }
    }
    
    func setLocalNoti() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "It's time!!!"
        content.body = "Don't forget to practice everyday"
        content.sound = UNNotificationSound.default
        
        let date = Date()
        var triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second], from: date)
        triggerDaily.hour = Int(UserDefaults.standard.string(forKey: "hourNoti") ?? "9")
        triggerDaily.minute = Int(UserDefaults.standard.string(forKey: "minuteNoti") ?? "0")
        triggerDaily.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        
        let identifier = "Englishor"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("center add error \(error)")
            }
        }
        content.categoryIdentifier = "Englishor"
    }

}
