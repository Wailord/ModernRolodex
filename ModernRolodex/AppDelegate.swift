//
//  AppDelegate.swift
//  ModernRolodex
//
//  Created by Ryan Fox on 5/4/18.
//  Copyright © 2018 Wailord. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = ViewController()
        
        self.window?.makeKeyAndVisible()
        return true
    }
}

