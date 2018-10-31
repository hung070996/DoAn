//
//  Lv2Cell.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable
import AMPopTip

protocol Lv1CellDelegate: class {
    func clickLoud(cell: Lv1Cell, frameButton: CGRect)
}

class Lv1Cell: UITableViewCell, NibReusable {

    let popTip = PopTip()
    weak var delegate: Lv1CellDelegate?
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        popTip.shouldDismissOnTap = true
        popTip.font = Utils.shared.globalFont
    }
    
    override func prepareForReuse() {
        popTip.hide(forced: true)
    }
    
    @IBAction func clickLoud(_ sender: UIButton) {
        delegate?.clickLoud(cell: self, frameButton: sender.frame)
    }
}
