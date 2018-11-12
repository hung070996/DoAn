//
//  SettingViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 11/12/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SwiftyButton

class SettingViewController: UIViewController {

    @IBOutlet weak var doneButton: PressableButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeButton: PressableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isHidden = true
        timePicker.isHidden = true
        setTitleTimeButton()
    }
    
    func setTitleTimeButton() {
        let hour = UserDefaults.standard.string(forKey: "hourNoti")
        let minute = UserDefaults.standard.string(forKey: "minuteNoti")
        timeButton.setTitle(hour! + ":" + minute!, for: .normal)
    }
    
    @IBAction func clickDone(_ sender: Any) {
        let hour = DateFormatter()
        hour.dateFormat = "HH"
        let stringHour = hour.string(from: (timePicker?.date)!)
        let minute = DateFormatter()
        minute.dateFormat = "mm"
        let stringMinute = minute.string(from: (timePicker?.date)!)
        UserDefaults.standard.set(stringHour, forKey: "hourNoti")
        UserDefaults.standard.set(stringMinute, forKey: "minuteNoti")
        Utils.shared.setLocalNoti()
        doneButton.isHidden = true
        timePicker.isHidden = true
        timeButton.isHidden = false
        setTitleTimeButton()
    }
    
    @IBAction func clickSetTime(_ sender: Any) {
        doneButton.isHidden = false
        timePicker.isHidden = false
        timeButton.isHidden = true
    }
}
