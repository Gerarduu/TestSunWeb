//
//  FakeSplashVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import UIKit

class FakeSplashVC: BaseVC {
    
    private var fakeSplashVM: FakeSplashVM! {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVM()
    }
    
    func setVM() {
        fakeSplashVM = FakeSplashVM(delegate: self)
    }
    
    func loadData() {
        startWaiting()
        fakeSplashVM.loadData()
    }
    
    func pushHome() {
        Navigation.shared.setHome()
    }
}

extension FakeSplashVC: FakeSplashVMDelegate {
    func didLoadData() {
        stopWaiting()
        pushHome()
    }
    
    func error(error: Error) {
        stopWaiting()
        self.showPopup(withTitle: "error.generic", withText: error.localizedDescription, withButton: "error.retry", completion: { (retry,_) in
            self.loadData()
        })
    }
}
