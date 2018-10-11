//
//  HomeViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/11/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeViewController: UIViewController {

    @IBAction func clickMenu(_ sender: Any) {
        revealViewController()?.revealToggle(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
