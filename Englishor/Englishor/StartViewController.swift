//
//  StartViewController.swift
//  Englishor
//
//  Created by Do Hung on 10/16/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Floaty

class StartViewController: UIViewController {

    @IBOutlet weak var floaty: Floaty!
    
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
    }
}
