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
            copyDatabaseIfNeeded()
            let path = NSSearchPathForDirectoriesInDomains(
                .documentDirectory, .userDomainMask, true
                ).first!
            
            return try Connection("\(path)/DoAnDB.db")
        } catch {
            return nil
        }
    }
    
    func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("DoAnDB.db")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("DoAnDB.db")
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        
    }
}
