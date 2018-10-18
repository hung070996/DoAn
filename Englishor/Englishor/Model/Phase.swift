//
//  Phase.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

class Phase {
    
    static let shared = Phase()
    
    var topic: Topic?
    var difficulty: Difficulty?
    var pointLv1: Int?
    var pointLv2: Int?
    var pointLv3: Int?
    var pointLv4: Int?
    var pointLv5: Int?
    var date: Date?
    
    private init() {}
}
