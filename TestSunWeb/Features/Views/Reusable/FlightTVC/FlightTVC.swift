//
//  FlightTVC.swift
//  TestSunWeb
//
//  Created by Gerard Riera on 09/03/2021.
//

import UIKit

protocol FlightTVCDelegate: class {
    func didSelectFlight(flight: FlightObject)
    func didSelectAirlne(airline: String)
}

class FlightTVC: UITableViewCell {
    
    private var flight: FlightObject!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var toDescLbl: UILabel!
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var airlineLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    weak var delegate: FlightTVCDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupTaps()
        setupUI()
    }
    
    func setup() {
        self.contentView.isUserInteractionEnabled = true
        self.airlineLbl.isUserInteractionEnabled = true
    }
    
    func setupTaps() {
        let tapFlight = UITapGestureRecognizer(target: self, action: #selector(didSelectFlight))
        tapFlight.numberOfTouchesRequired = 1
        self.contentView.addGestureRecognizer(tapFlight)
        
        let tapAirline = UITapGestureRecognizer(target: self, action: #selector(didSelectAirline))
        tapAirline.numberOfTouchesRequired = 1
        self.airlineLbl.addGestureRecognizer(tapAirline)
    }
    
    @objc func didSelectFlight() {
        self.delegate?.didSelectFlight(flight: self.flight)
    }
    
    @objc func didSelectAirline() {
        self.delegate?.didSelectAirlne(airline: self.flight.airline)
    }
    
    func setupUI() {
        fromLbl.font = UIFont.boldSystemFont(ofSize: 20)
        toDescLbl.font = UIFont.systemFont(ofSize: 10)
        toLbl.font = UIFont.boldSystemFont(ofSize: 20)
        airlineLbl.font = UIFont.systemFont(ofSize: 10)
        airlineLbl.textColor = .gray
        priceLbl.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func configureCell(with flight: FlightObject) {
        
        self.accessoryType = .none
        
        self.flight = flight
        
        guard let checked = flight.checked else {return}
        if checked == true {
            self.accessoryType = .checkmark
        }
        
        fromLbl.text = self.flight.departureAirportCode
        
        toDescLbl.text = "flight_tvc.to".localized
        
        toLbl.text = self.flight.arrivalAirportCode
        
        airlineLbl.text = self.flight.airline + "flight_tvc.airlines".localized
        
        guard let price = self.flight.price else {
            priceLbl.text = "N/D"
            return
        }
        priceLbl.text = "\(price) €"
    }
}
