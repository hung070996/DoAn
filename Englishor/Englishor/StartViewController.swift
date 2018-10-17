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
        
        floaty.addItem("Change topic",
                       icon: UIImage(named: "Food")!,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        
                        self.floaty.close()
        })
        floaty.addItem("Change difficulty",
                       icon: UIImage(named: "Home")!,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        
                        self.floaty.close()
        })
        floaty.addItem("Analytics",
                       icon: UIImage(named: "Sport")!,
                       titlePosition: .right,
                       handler: { [unowned self] item in
                        
                        self.floaty.close()
        })
        setupPressableButton(color: .green, shadow: .lightGray, button: readyButton)
    }
    
    @IBAction func clickReady(_ sender: PressableButton) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Lv1ViewController") as? Lv1ViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
