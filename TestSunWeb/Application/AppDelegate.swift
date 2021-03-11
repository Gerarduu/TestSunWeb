//
//  AppDelegate.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupFirstScreen()
        return true
    }
    
    func setupFirstScreen() {
        Navigation.shared.setSplash()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        FlightManager.shared.saveContext()
    }
}

