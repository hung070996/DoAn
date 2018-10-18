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

    let globalFont = UIFont(name: "Chalkboard SE", size: 20)!

    func setupPressableButton(color: UIColor, shadow: UIColor, button: PressableButton) {
        button.colors = .init(button: color, shadow: shadow)
        button.shadowHeight = 10
        button.cornerRadius = 10
        button.depth = 0.5
    }

    func getRandom<T>(in array: [T], quantity: Int) -> [T] {
        var result = [T]()
        var temp = array
        if quantity <= array.count {
            for _ in 0..<quantity {
                let random = Int.random(in: 0..<temp.count)
                result.append(temp[random])
                temp.remove(at: random)
            }
        }
        return result
    }
