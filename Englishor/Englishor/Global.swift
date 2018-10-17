//
//  Global.swift
//  Englishor
//
//  Created by do.tien.hung on 10/17/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit
import SwiftyButton

func setupPressableButton(color: UIColor, shadow: UIColor, button: PressableButton) {
    button.colors = .init(button: color, shadow: shadow)
    button.shadowHeight = 10
    button.cornerRadius = 10
    button.depth = 0.5
}
