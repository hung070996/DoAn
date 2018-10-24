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

class NavigationView: UIView, NibOwnerLoadable {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var label: UILabel!
    
    weak var delegate: NavigationViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
        
    }

    @IBAction func clickNext(_ sender: UIButton) {
        delegate?.clickNext()
    }
    
    @IBAction func clickBack(_ sender: Any) {
        self.parentViewController?.navigationController?.popViewController(animated: true)
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

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
