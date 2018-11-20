//
//  SplashViewController.swift
//  Englishor
//
//  Created by do.tien.hung on 11/20/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import RevealingSplashView

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "appicon")!, iconInitialSize: CGSize(width: 150, height: 150), backgroundColor: UIColor(red: 252/256, green: 229/256, blue: 185/256, alpha: 1.0))
        view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation { [weak self] in
            guard let `self` = self else { return }
            self.tabBarController?.tabBar.isHidden = false
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseTopicViewController") as? ChooseTopicViewController
            self.navigationController?.pushViewController(vc!, animated: false)
        }
    }
}
