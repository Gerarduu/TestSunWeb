//
//  HeaderSection.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 11/03/2021.
//

import UIKit

class SectionHeader: UIViewController {
    
    @IBOutlet weak var flightImgView: UIImageView!
    @IBOutlet weak var sectionTitleLbl: UILabel!
    private var sectionTitle: String!
    private var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    init(title: String, image: UIImage!) {
        self.sectionTitle = title
        self.image = image
        super.init(nibName: kSectionHeader, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.backgroundColor = kColorGray
        sectionTitleLbl.font = UIFont.boldSystemFont(ofSize: 20)
        sectionTitleLbl.text = self.sectionTitle
        flightImgView.image = self.image
    }
}
