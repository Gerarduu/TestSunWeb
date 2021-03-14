//
//  HeaderTVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 14/03/2021.
//

import Foundation
import UIKit

class HeaderTVC: UITableViewCell {
    
    @IBOutlet weak var headerLbl: UILabel!
    private var headline: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        headerLbl.font = UIFont.boldSystemFont(ofSize: 15)
    }
    
    func configureCell(headline: String) {
        self.headline = headline
        self.headerLbl.text = headline
    }
}
