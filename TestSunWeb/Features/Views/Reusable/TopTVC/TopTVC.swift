//
//  TopTVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 14/03/2021.
//

import UIKit
import Kingfisher

class TopTVC: UITableViewCell {
    
    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var snapshotImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() {
        self.logoImg.layer.cornerRadius = self.logoImg.frame.width/2
    }
    
    func configureCell(logo:URL, snapshot:URL) {
        DispatchQueue.global(qos: .background).async {
            let resourceLogo = ImageResource(downloadURL: logo)
            let resourceSnapshot = ImageResource(downloadURL: snapshot)
            DispatchQueue.main.async {
                self.logoImg.kf.setImage(
                    with: resourceLogo,
                    options: [
                        .cacheOriginalImage
                    ]
                )
                self.snapshotImg.kf.setImage(
                    with: resourceSnapshot,
                    options: [
                        .cacheOriginalImage
                    ]
                )
            }
        }
    }
}
