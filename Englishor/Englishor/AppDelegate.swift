//
//  AppDelegate.swift
//  Englishor
//
//  Created by Do Hung on 10/11/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import UIKit
import ApiAI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "59ffc1de38674081871181580f1f5a6b"
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration

        if UserDefaults.standard.string(forKey: "hourNoti") == nil {
            UserDefaults.standard.set("09", forKey: "hourNoti")
            UserDefaults.standard.set("00", forKey: "minuteNoti")
            Utils.shared.setLocalNoti()
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Chalkboard SE", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UITabBar.appearance().tintColor = UIColor.black
        return true
    }
}

