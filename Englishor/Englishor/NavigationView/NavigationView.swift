//
//  NavigationView.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

protocol NavigationViewDelegate: class {
    func clickNext()
}

protocol BackNavigationViewDelegate: class {
    func clickBack()
}

class NavigationView: UIView, NibOwnerLoadable {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var label: UILabel!
    
    weak var delegate: NavigationViewDelegate?
    weak var backDelegate: BackNavigationViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
    }

    @IBAction func clickNext(_ sender: UIButton) {
        delegate?.clickNext()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.parentViewController?.navigationController?.popViewController(animated: true)
        backDelegate?.clickBack()
    }
    
    func setTitle(title: String) {
        label.text = title
    }
    
    func setHiddenView(nextLv: Bool, title: Bool, back: Bool) {
        nextButton.isHidden = nextLv
        label.isHidden = title
        backButton.isHidden = back
    }
}
