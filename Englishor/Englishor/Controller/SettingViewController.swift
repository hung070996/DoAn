//
//  SettingViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 11/12/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SQLite
import SwiftyButton
import Toast_Swift

class SettingViewController: UIViewController {

    @IBOutlet weak var clearButton: PressableButton!
    @IBOutlet weak var doneButton: PressableButton!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var timeButton: PressableButton!
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var navigationView: NavigationView!
    
    let phases = Table("Phase")
    
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
        view.makeToast("Set time to get notification successfully")
    }
    
    @IBAction func clickSetTime(_ sender: Any) {
        doneButton.isHidden = false
        timePickerView.isHidden = false
        timeButton.isHidden = true
    }
    
    @IBAction func clickClearData(_ sender: PressableButton) {
        let actionSheet = UIActionSheet(title: "Do you want to clear your practice data?",
                                        delegate: self,
                                        cancelButtonTitle: "No",
                                        destructiveButtonTitle: nil,
                                        otherButtonTitles: "Yes")
        actionSheet.show(in: self.view)
    }
}

extension SettingViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            do {
                try DatabaseManager.shared.connection?.run(phases.delete())
                view.makeToast("Clear data successfully")
            } catch {
                view.makeToast("Clear data fail")
            }
        }
    }
}
