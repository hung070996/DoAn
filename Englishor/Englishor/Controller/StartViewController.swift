//
//  StartViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/16/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Floaty
import SwiftyButton

class StartViewController: UIViewController {

    @IBOutlet weak var floaty: Floaty!
    @IBOutlet weak var readyButton: PressableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FloatyManager.defaultInstance().font = globalFont
        
        floaty.addItem("Change topic",
                       icon: Phase.shared.topic?.icon,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: ChooseTopicViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        self.floaty.close()
        })
        floaty.addItem("Change difficulty",
                       icon: UIImage(named: "Home")!,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        for controller in self.navigationController!.viewControllers as Array {
                            if controller.isKind(of: ChooseDifficultyViewController.self) {
                                self.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                        self.floaty.close()
        })
        floaty.addItem("Analytics",
                       icon: UIImage(named: "analytic")!,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChartViewController") as? ChartViewController
                        self.navigationController?.pushViewController(vc!, animated: true)
                        self.floaty.close()
        })

        setupPressableButton(color: .green, shadow: .lightGray, button: readyButton)
    }
    
    @IBAction func clickReady(_ sender: PressableButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
            guard let `self` = self else { return }
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv1ViewController") as? Lv1ViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
