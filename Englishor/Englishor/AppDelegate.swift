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
        return true
    }
}

