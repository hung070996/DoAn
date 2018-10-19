//
//  Lv2Cell.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

protocol Lv1CellDelegate: class {
    func clickLoud(cell: Lv1Cell, frameButton: CGRect)
}

class Lv1Cell: UITableViewCell, NibReusable {

    weak var delegate: Lv1CellDelegate?
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func clickLoud(_ sender: UIButton) {
        delegate?.clickLoud(cell: self, frameButton: sender.frame)
    }
}
