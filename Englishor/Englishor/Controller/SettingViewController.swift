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
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var navigationView: NavigationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isHidden = true
        timePickerView.isHidden = true
        timePickerView.layer.borderWidth = 0.5
        timePickerView.layer.borderColor = UIColor.gray.cgColor
        setTitleTimeButton()
        navigationView.setHiddenView(nextLv: true, title: false, back: true)
        navigationView.setTitle(title: "Setting")
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
        timePickerView.isHidden = true
        timeButton.isHidden = false
        setTitleTimeButton()
    }
    
    @IBAction func clickSetTime(_ sender: Any) {
        doneButton.isHidden = false
        timePickerView.isHidden = false
        timeButton.isHidden = true
    }
}
