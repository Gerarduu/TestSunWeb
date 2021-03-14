//
//  DescriptionTVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 14/03/2021.
//

import UIKit

class DescriptionTVC: UITableViewCell {
    
    @IBOutlet weak var descLbl: UILabel!
    private var desc: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(description: String) {
        self.desc = description
        self.descLbl.text = self.desc
    }
}
