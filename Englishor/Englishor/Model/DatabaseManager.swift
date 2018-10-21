//
//  DatabaseManager.swift
//  Englishor
//
//  Created by do.tien.hung on 10/19/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    
    var connection : Connection? {
        do {
            let path = Bundle.main.path(forResource: "DoAnDB", ofType: "db")!
            return try Connection(path)
        } catch {
            return nil
        }
    }
}
