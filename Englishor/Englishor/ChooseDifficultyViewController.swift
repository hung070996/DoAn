//
//  ChooseDifficultyViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/16/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SwiftyButton

class ChooseDifficultyViewController: UIViewController {
    @IBOutlet weak var easyButton: PressableButton!
    @IBOutlet weak var mediumButton: PressableButton!
    @IBOutlet weak var hardButton: PressableButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPressableButton(color: .green, shadow: .lightGray, button: easyButton)
        setupPressableButton(color: .orange, shadow: .lightGray, button: mediumButton)
        setupPressableButton(color: .red, shadow: .lightGray, button: hardButton)
    }
    

    @IBAction func chooseDifficulty(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
            guard let `self` = self else { return }
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StartViewController") as? StartViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
