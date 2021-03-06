//
//  LoadingVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import UIKit

class LoadingVC: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var color: UIColor?
    let containerView: UIView?
    
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
        
    init(color: UIColor? = UIColor.white, containerView: UIView? = nil) {
        self.color = color
        self.containerView = containerView
        super.init(nibName: kLoadingVC, bundle: nil)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let color = self.color {
            activityIndicator.color = color
        } else {
            activityIndicator.color = UIColor.white
        }
    }
    //MARK: - Adds the LoadingVC to the given container view.
    func start() {
        if let container = containerView {
            container.addSubview(view)
            UIView.addConstraints(self.view, in: container)
        } else if activityIndicator.isAnimating { return }
        
        self.activityIndicator.alpha = 1.0
        self.activityIndicator.startAnimating()
        self.view.alpha = 1.0
    }
    //MARK: - Stops the LoadingVC.
    func stop() {
        if activityIndicator == nil { return }
        if activityIndicator.isAnimating {
            self.activityIndicator.alpha = 0.0
            self.activityIndicator.stopAnimating()
            self.view.alpha = 0.0
            self.view.removeFromSuperview()
        }
    }
}


