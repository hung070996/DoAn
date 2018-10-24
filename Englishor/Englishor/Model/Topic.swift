//
//  Topic.swift
//  Englishor
//
//  Created by Do Hung on 10/15/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit

enum Topic: Int {
    case animal = 1, school, food, home, sport, color
    
    var name: String {
        switch self {
        case .animal:
            return "Animal"
        case .school:
            return "School"
        case .food:
            return "Food"
        case .home:
            return "Home"
        case .sport:
            return "Sport"
        case .color:
            return "Color"
        }
    }
    
    var icon: UIImage {
        return UIImage(named: name) ?? UIImage()
    }
    
    var radian: CGFloat {
        let unit = CGFloat.pi / 6
        switch self {
        case .animal:
            return unit * 7
        case .school:
            return unit * 9
        case .food:
            return unit * 11
        case .home:
            return unit * 1
        case .sport:
            return unit * 3
        case .color:
            return unit * 5
        }
    }
}
