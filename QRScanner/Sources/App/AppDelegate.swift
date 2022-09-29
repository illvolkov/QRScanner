//
//  AppDelegate.swift
//  QRScanner
//
//  Created by Ilya Volkov on 29.09.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = CameraController()
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

