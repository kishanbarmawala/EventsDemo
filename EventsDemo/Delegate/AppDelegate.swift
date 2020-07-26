//
//  AppDelegate.swift
//  EventsDemo
//
//  Created by Kishan Barmawala on 17/07/20.
//  Copyright © 2020 Kishan Barmawala. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = UIColor.black
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        return true
    }
    
}

