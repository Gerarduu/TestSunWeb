//
//  FlightTVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 09/03/2021.
//

import UIKit

class FlightTVC: UITableViewCell {
    
    
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toDescLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var airlineLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI() { }
    
    func configureCell(with flight: FlightObject) {
        self.accessoryType = .none
        guard let checked = flight.checked else {return}
        if checked == true {
            self.accessoryType = .checkmark
        }
        
        fromLbl.font = UIFont.boldSystemFont(ofSize: 20)
        fromLbl.text = flight.departureAirportCode
        
        toDescLbl.font = UIFont.systemFont(ofSize: 10)
        toDescLbl.text = "flight_tvc.to".localized
        
        toLbl.font = UIFont.boldSystemFont(ofSize: 20)
        toLbl.text = flight.arrivalAirportCode
        
        airlineLbl.font = UIFont.systemFont(ofSize: 10)
        airlineLbl.textColor = .gray
        airlineLbl.text = flight.airline + "flight_tvc.airlines".localized
        
        priceLbl.font = UIFont.boldSystemFont(ofSize: 20)
        guard let price = flight.price else {
            priceLbl.text = "N/D"
            return
        }
        priceLbl.text = "\(price) €"
    }
}
