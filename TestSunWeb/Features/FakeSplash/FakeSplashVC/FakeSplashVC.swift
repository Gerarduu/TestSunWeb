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
        fakeSplashVM.loadData()
    }
}

extension FakeSplashVC: FakeSplashVMDelegate {
    
}
