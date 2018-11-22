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
//            let path = Bundle.main.path(forResource: "DoAnDB", ofType: "db")!
//            return try Connection(path)
//            return try Connection("/Users/dohung/Desktop/untitled folder 3/DoAn/Englishor/Englishor/Supporting/DoAnDB.db")
//            let path = NSSearchPathForDirectoriesInDomains(
//                .documentDirectory, .userDomainMask, true
//                ).first!
            var path = NSSearchPathForDirectoriesInDomains(
                .applicationSupportDirectory, .userDomainMask, true
                ).first! + Bundle.main.bundleIdentifier!
            
            // create parent directory iff it doesn’t exist
            try FileManager.default.createDirectory(
                atPath: path, withIntermediateDirectories: true, attributes: nil
            )
            return try Connection("\(path)/DoAnDB.db")
        } catch {
            return nil
        }
    }
}
