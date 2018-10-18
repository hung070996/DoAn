//
//  Difficulty.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

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
    
    var timeOfConversation: Int {
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
