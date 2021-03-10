//
//  HomeVM.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation

protocol HomeVMDelegate: class {
    func didSelectFlight()
}

class HomeVM {
    
    weak var delegate: HomeVMDelegate?
    private var flights: [FlightObject]!
    
    var outboundFlights: [FlightObject]! {
        return self.flights?
            .filter{$0.outBound == 1}
            .sorted(by: {
                guard let first: NSNumber = $0.price, let second: NSNumber = $1.price else {
                    return false
                }
                return first.intValue < second.intValue
            })
    }
    
    var inboundFlights: [FlightObject]! {
        return self.flights?
            .filter{$0.outBound == 0}
            .sorted(by: {
                guard let first: NSNumber = $0.price, let second: NSNumber = $1.price else {
                    return false
                }
                return first.intValue < second.intValue
            })
    }
    
    var filteredInboundFlights: [FlightObject]!
    
    init(delegate: HomeVMDelegate) {
        self.delegate = delegate
        self.flights = FlightManager.shared.getFlights()
    }
    
    func loadData() {
        guard let cheapestFlight = self.outboundFlights.first else { return }
        selectOutboundFlight(_flight: cheapestFlight)
    }
    
    func selectOutboundFlight(_flight:FlightObject) {
        
        for flight in outboundFlights {
            flight.checked = false
        }
        
        _flight.checked = true
        
        for flight in inboundFlights {
            flight.checked = false
            flight.visible = false
        }
        
        /// If we have flights from the same airline that that depart from airport B to airport A, show them.
        if inboundFlights.filter({ $0.airline == _flight.airline }).count > 0 {
            for flight in inboundFlights {
                if flight.airline == _flight.airline
                    && flight.departureAirportCode == _flight.arrivalAirportCode
                    && flight.arrivalAirportCode == _flight.departureAirportCode {
                    flight.visible = true
                }
            }
        } else { /// If we don't have flights from the same airline that depart from airport B to airport A, then show the flights that depart from airport B to airport A from any airline.
            for flight in inboundFlights {
                if flight.departureAirportCode == _flight.arrivalAirportCode
                    && flight.arrivalAirportCode == _flight.departureAirportCode {
                    flight.visible = true
                }
            }
        }
        
        self.filteredInboundFlights = inboundFlights.filter{$0.visible == true}
        if let cheapestFlight = self.filteredInboundFlights.first {
            selectInboundFlight(_flight: cheapestFlight)
        }
        self.delegate?.didSelectFlight()
    }
        
    func selectInboundFlight(_flight:FlightObject) {
        for flight in filteredInboundFlights {
            flight.checked = false
        }
        _flight.checked = true
        self.delegate?.didSelectFlight()
    }
}

