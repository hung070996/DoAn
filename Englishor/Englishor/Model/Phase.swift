//
//  Phase.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

class Phase: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(pointLv1, forKey: "pointLv1")
        aCoder.encode(pointLv2, forKey: "pointLv2")
        aCoder.encode(pointLv3, forKey: "pointLv3")
        aCoder.encode(pointLv4, forKey: "pointLv4")
        aCoder.encode(pointLv5, forKey: "pointLv5")
        aCoder.encode(date, forKey: "date")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let pointLv1 = aDecoder.decodeObject(forKey: "pointLv1") as! Int
        let pointLv2 = aDecoder.decodeObject(forKey: "pointLv2") as! Int
        let pointLv3 = aDecoder.decodeObject(forKey: "pointLv3") as! Int
        let pointLv4 = aDecoder.decodeObject(forKey: "pointLv4") as! Int
        let pointLv5 = aDecoder.decodeObject(forKey: "pointLv5") as! Int
        let date = aDecoder.decodeObject(forKey: "date") as! String
        self.init(pointLv1: pointLv1, pointLv2: pointLv2, pointLv3: pointLv3, pointLv4: pointLv4, pointLv5: pointLv5, date: date)
    }
    
    
    static let shared = Phase()
    
    var topic: Topic?
    var difficulty: Difficulty!
    var pointLv1: Int?
    var pointLv2: Int?
    var pointLv3: Int?
    var pointLv4: Int?
    var pointLv5: Int?
    var date: String?
    
    private override init() {}
    
    private init(pointLv1: Int, pointLv2: Int, pointLv3: Int, pointLv4: Int, pointLv5: Int, date: String) {
        self.pointLv1 = pointLv1
        self.pointLv2 = pointLv2
        self.pointLv3 = pointLv3
        self.pointLv4 = pointLv4
        self.pointLv5 = pointLv5
        self.date = date
    }
}
