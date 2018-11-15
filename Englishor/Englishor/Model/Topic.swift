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
    
    var iconStraight: UIImage {
        return UIImage(named: name2) ?? UIImage()
    }
    
    var name2: String {
        switch self {
        case .animal:
            return "animal-1"
        case .school:
            return "school-1"
        case .food:
            return "food-1"
        case .home:
            return "home-1"
        case .sport:
            return "sport-1"
        case .color:
            return "color-1"
        }
    }
}
