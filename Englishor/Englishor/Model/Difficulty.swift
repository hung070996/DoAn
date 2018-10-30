//
//  Difficulty.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import UIKit

enum Difficulty: Int {
    case easy = 0, medium, hard
    
    var numberOfQuestion: Int {
        switch self {
        case .easy:
            return 5
        case .medium:
            return 7
        case .hard:
            return 10
        }
    }
    
    var image: UIImage {
        var string = ""
        switch self {
        case .easy:
            string = "easy"
        case .medium:
            string = "medium"
        case .hard:
            string = "hard"
        }
        return UIImage(named: string) ?? UIImage()
    }
    
    var timeOfLevel: (lv1: Double, answerLv1: Double, lv2: Double, lv3: Double) {
        switch self {
        case .easy:
            return (lv1: 10, answerLv1: 30, lv2: 30, lv3: 60)
        case .medium:
            return (lv1: 90, answerLv1: 150, lv2: 90, lv3: 240)
        case .hard:
            return (lv1: 120, answerLv1: 180, lv2: 120, lv3: 300)
        }
    }
    
    var timeOfConversation: Double {
        switch self {
        case .easy:
            return 30
        case .medium:
            return 60
        case .hard:
            return 90
        }
    }
}
