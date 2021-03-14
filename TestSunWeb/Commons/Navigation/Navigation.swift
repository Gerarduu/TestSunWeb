//
//  Navigation.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import UIKit

class Navigation {
    static let shared = Navigation()
    private let window = UIWindow(frame: UIScreen.main.bounds)
    
    func setSplash() {
        let fakeSplashVC = kStoryboardMain.instantiateViewController(withIdentifier: kFakeSplashVC)
        setRootController(UINavigationController(rootViewController: fakeSplashVC))
    }
    
    func setHome() {
        DispatchQueue.main.async { [weak self] in
            if let homeVC = kStoryboardHome.instantiateViewController(withIdentifier: kHomeVC) as? HomeVC {
                self?.setRootController(UINavigationController(rootViewController: homeVC))
            }
        }
    }
    
    private func setRootController(_ controller: UIViewController, animated: Bool = false, completion: (() -> Void)? = nil ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            window.rootViewController = controller
            CATransaction.commit()
        } else {
            window.rootViewController = controller
            completion?()
        }
        window.makeKeyAndVisible()
    }
}
