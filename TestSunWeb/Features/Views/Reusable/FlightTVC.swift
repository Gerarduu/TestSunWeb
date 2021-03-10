//
//  FlightTVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 09/03/2021.
//

import UIKit

class FlightTVC: UITableViewCell {
    
    @IBOutlet weak var fromLbl: UILabel!
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
        fromLbl.text = flight.departureAirportCode
        toLbl.text = flight.arrivalAirportCode
        airlineLbl.text = flight.airline
        guard let price = flight.price else {
            priceLbl.text = "N/D"
            return
        }
        priceLbl.text = "\(price) €"
    }
}
