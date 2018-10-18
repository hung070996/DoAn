//
//  NavigationView.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class NavigationView: UIView, NibOwnerLoadable {

    @IBOutlet weak var label: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }

    @IBAction func clickBack(_ sender: Any) {
        
    }
}
