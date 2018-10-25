//
//  ResultViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/23/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import JYRadarChart
import SwiftyButton

class ResultViewController: UIViewController {
    
    @IBOutlet weak var backToHomeButton: PressableButton!
    @IBOutlet weak var chartView: JYRadarChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChart()
        setupPressableButton(color: nil, shadow: nil, button: backToHomeButton)
    }
    
    func setupChart() {
        let phase = Phase.shared
        let data = [phase.pointLv1, phase.pointLv2, phase.pointLv3, phase.pointLv4, phase.pointLv5]
        chartView.dataSeries = [data]
        chartView.steps = 5
        chartView.backgroundColor = UIColor.clear
        chartView.minValue = 0
        chartView.maxValue = 100
        chartView.fillArea = true
        chartView.colorOpacity = 0.7
        chartView.attributes = ["Lv1", "Lv2", "Lv3", "Lv4", "Lv5"]
        chartView.setColors([UIColor.red])
        chartView.drawPoints = true
        chartView.drawStrokePoints = true
        chartView.pointsStrokeSize = 5
    }
    
    @IBAction func clickBackToHome(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: StartViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}
