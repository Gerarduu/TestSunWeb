//
//  ViewController.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import UIKit

class BaseVC: UIViewController {
    var waitingView: LoadingVC?
    
    private var isShownPopup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = kColorGray
    }
    //MARK: - Sets up the Navigation bar
    func setupNavBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    //MARK: - Checks if there is an instance of LoadingVC, if not, calls LoadingVC start method
    func startWaiting(color: UIColor = .white) {
        DispatchQueue.main.async {
            if self.waitingView == nil {
                self.waitingView = LoadingVC(color: color, containerView: self.view)
            }
            self.view.subviews.filter { $0.isKind(of: LoadingVC.self) }
                .forEach { $0.removeFromSuperview() }
            self.waitingView?.start()
        }
    }
    //MARK: - Calls LoadingVC stop method
    func stopWaiting(_ silent: Bool = false) {
        DispatchQueue.main.async {
            self.waitingView?.stop()
        }
    }
    
    //MARK: - Checks if there is a popup still showing and if not, shows an iOS native popup that displays the given parameters.
    /// - parameter withTitle: The title of the popup.
    /// - parameter withMessage: The message of the popup.
    /// - parameter button: The first button of the popup.
    /// - parameter button2: The second button of the popup.
    /// - parameter completion: The completion block
     
    func showPopup(withTitle title: String?, withText text: String?, withButton button: String?, button2: String? = nil, completion: ((Bool?, Bool?) -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return}
            if !self.isShownPopup, self.presentedViewController == nil, UIApplication.shared.applicationState == .active {
                self.isShownPopup = true
                
                let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: button, style: .default, handler: { [weak self]
                    (value) in
                    self?.isShownPopup = false
                    completion?(true, nil)
                }))
                
                if let button2 = button2 {
                    alert.addAction(UIAlertAction(title: button2, style: .default, handler: { [weak self]
                        (value) in
                        self?.isShownPopup = false
                        completion?(nil, true)
                    }))
                }
        
                self.present(alert, animated: true, completion: nil)
                
            } else {
                debugPrint("There is still a popup ...")
            }
        }
    }
}

