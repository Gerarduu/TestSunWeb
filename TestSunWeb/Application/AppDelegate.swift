//
//  AppDelegate.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import UIKit
import CoreData

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
        saveContext()
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: kContainer)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

