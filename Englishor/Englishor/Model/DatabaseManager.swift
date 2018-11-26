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
//            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//                .appendingPathComponent("DoAnDB.db")
//            print(fileURL)
            return try Connection("/Users/do.tien.hung/Desktop/DoAn/DoAn/Englishor/Englishor/Supporting/DoAnDB.db")
//            let path = NSSearchPathForDirectoriesInDomains(
//                .documentDirectory, .userDomainMask, true
//                ).first!
//            let path = NSSearchPathForDirectoriesInDomains(
//                .applicationSupportDirectory, .userDomainMask, true
//                ).first! + Bundle.main.bundleIdentifier!
//
//            // create parent directory iff it doesn’t exist
//            try FileManager.default.createDirectory(
//                atPath: path, withIntermediateDirectories: true, attributes: nil
//            )
//            return try Connection("\(path)/DoAnDB.db")
        } catch {
            return nil
        }
    }
}
