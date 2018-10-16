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
        setupButton(color: .green, shadow: .lightGray, button: easyButton)
        setupButton(color: .orange, shadow: .lightGray, button: mediumButton)
        setupButton(color: .red, shadow: .lightGray, button: hardButton)
    }
    
    func setupButton(color: UIColor, shadow: UIColor, button: PressableButton) {
        button.colors = .init(button: color, shadow: shadow)
        button.shadowHeight = 10
        button.cornerRadius = 10
        button.depth = 0.5
    }

    @IBAction func chooseDifficulty(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "StartViewController") as? StartViewController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
}
