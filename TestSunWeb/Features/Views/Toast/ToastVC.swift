//
//  ToastView.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 10/03/2021.
//

import UIKit

class ToastVC: UIViewController {
    
    @IBOutlet weak var routePriceDescLbl: UILabel!
    @IBOutlet weak var routePriceValLbl: UILabel!
    private var containerView: UIView!
    private var price: Float!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(containerView: UIView) {
        self.containerView = containerView
        super.init(nibName: kToast, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        routePriceDescLbl.textColor = .white
        routePriceDescLbl.text = "toast.route_price_desc".localized
        routePriceValLbl.textColor = .white
        self.view.isHidden = true
    }
    
    func configure(price: Float) {
        self.price = price
        self.routePriceValLbl.text = "\(price) €"
    }
    
    func add() {
        if let container = containerView {
            self.view.frame = CGRect(x: 0, y: containerView.frame.size.height, width: containerView.frame.size.width, height: self.view.frame.size.height)
            container.addSubview(self.view)
        }
    }
    
    func show() {
        if self.view.isHidden {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                self.view.center.y -= self.view.frame.size.height
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.view.isHidden = false
        }
    }
    
    func hide() {
        if !self.view.isHidden {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                self.view.center.y += self.view.frame.size.height
                self.view.layoutIfNeeded()
            }, completion: {_ in
                self.view.isHidden = true
            })
        }
    }
}
