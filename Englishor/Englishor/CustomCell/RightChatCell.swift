//
//  RightChatCell.swift
//  Englishor
//
//  Created by do.tien.hung on 10/22/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class RightChatCell: UITableViewCell, NibReusable {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        boundView.layer.borderColor = UIColor.black.cgColor
        boundView.layer.cornerRadius = 5
        boundView.layer.borderWidth = 1.0
    }
}
