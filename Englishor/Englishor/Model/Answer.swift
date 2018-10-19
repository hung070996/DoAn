//
//  Answer.swift
//  Englishor
//
//  Created by do.tien.hung on 10/19/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

enum Answer: Int {
    case a = 0, b, c, d
    
    var toString: String {
        switch self {
        case .a:
            return "a"
        case .b:
            return "ab"
        case .c:
            return "c"
        case .d:
            return "d"
        }
    }
}
