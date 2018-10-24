//
//  String+.swift
//  Englishor
//
//  Created by do.tien.hung on 10/24/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

extension String {
    func toIndexAnswer() -> Int {
        switch self {
        case "a":
            return 0
        case "b":
            return 1
        case "c":
            return 2
        case "d":
            return 3
        default:
            return -1
        }
    }
}
