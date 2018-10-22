//
//  Lv4ViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 10/22/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit

class Lv4ViewController: UIViewController {
    
    var a = ["asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd","asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd","asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd", "asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd","asd", "asdsdasdnbasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdsajd", "asdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajdasdsdasdnbsajd"]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellType: LeftChatCell.self)
        tableView.register(cellType: RightChatCell.self)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

}

extension Lv4ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return a.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
        if indexPath.row % 2 == 0 {
            let cell: LeftChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.avatar.image = UIImage(named: "microphone")
            cell.label.text = a[indexPath.row]
            return cell
        } else {
            let cell: RightChatCell = tableView.dequeueReusableCell(for: indexPath)
            cell.avatar.image = UIImage(named: "micro")
            cell.label.text = a[indexPath.row]
            return cell
        }
        
    }
    
    
}
