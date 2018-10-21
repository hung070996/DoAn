//
//  NavigationView.swift
//  Englishor
//
//  Created by do.tien.hung on 10/18/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import Reusable

class NavigationView: UIView, NibOwnerLoadable {

    @IBOutlet private weak var label: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadNibContent()
        
    }

    @IBAction func clickBack(_ sender: Any) {
        self.parentViewController?.navigationController?.popViewController(animated: true)
    }
    
    func setTitle(title: String) {
        label.text = title
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
