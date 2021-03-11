//
//  HomeVM.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation

protocol HomeVMDelegate: class {
    func didSelectOutboundFlight()
    func didSelectInboundFlight()
    func couldntSelectInboundFlight()
}

class HomeVM {
    
    weak var delegate: HomeVMDelegate?
    private var flights: [FlightObject]!
    private var selectedOutboundFlight: FlightObject?
    private var selectedInboundFlight: FlightObject?
    
    var routePrice: Float? {
        guard selectedOutboundFlight != nil, selectedInboundFlight != nil else {
            return nil
        }
        return selectedInboundFlight!.transportPrice + selectedOutboundFlight!.transportPrice
    }
    
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
        if let alreadyLaunched = Preferences.getPrefsHasAlreadyLaunched(), alreadyLaunched {
            loadSelectedFlights()
        } else {
            Preferences.setPrefsHasAlreadyLaunched(value: true)
            if let cheapestFlight = self.outboundFlights.first {
                selectOutboundFlight(outboundFlight: cheapestFlight)
            }
        }
    }
    
    func loadSelectedFlights() {
        self.selectedOutboundFlight = outboundFlights.first(where: {$0.checked == true})
        self.delegate?.didSelectOutboundFlight()
        self.filteredInboundFlights = inboundFlights.filter{$0.visible == true}
        if self.filteredInboundFlights.count > 0 {
            self.selectedInboundFlight = filteredInboundFlights.first(where: {$0.checked == true})
            self.delegate?.didSelectInboundFlight()
        } else {
            self.delegate?.couldntSelectInboundFlight()
        }
    }
    
    func selectOutboundFlight(outboundFlight:FlightObject) {
        
        self.selectedInboundFlight = nil
        self.selectedOutboundFlight = outboundFlight
        
        /// Uncheck all the previously selected outbound flights
        for flight in outboundFlights {
            flight.checked = false
        }
        /// Select the current one
        outboundFlight.checked = true
        
        /// Uncheck and hide all the inbound flights
        for flight in inboundFlights {
            flight.checked = false
            flight.visible = false
        }
        
        /// If we have inbound flights from the same airline that that depart from airport B to airport A, show them.
        if inboundFlights.filter({ $0.airline == outboundFlight.airline }).count > 0 {
            for flight in inboundFlights {
                if flight.airline == outboundFlight.airline
                    && flight.departureAirportCode == outboundFlight.arrivalAirportCode
                    && flight.arrivalAirportCode == outboundFlight.departureAirportCode {
                    flight.visible = true
                }
            }
        } else { /// If we don't have inbound flights from the same airline that depart from airport B to airport A, then show the inbound flights that depart from airport B to airport A from any airline.
            for flight in inboundFlights {
                if flight.departureAirportCode == outboundFlight.arrivalAirportCode
                    && flight.arrivalAirportCode == outboundFlight.departureAirportCode {
                    flight.visible = true
                }
            }
        }
        
        self.filteredInboundFlights = inboundFlights.filter{$0.visible == true}
        
        /// Select the cheapest inbound flight
        if let cheapestFlight = self.filteredInboundFlights.first {
            selectInboundFlight(inboundFlight: cheapestFlight)
        } else {
            self.delegate?.couldntSelectInboundFlight()
        }
        
        self.delegate?.didSelectOutboundFlight()
    }
        
    func selectInboundFlight(inboundFlight:FlightObject) {
        
        self.selectedInboundFlight = inboundFlight
        
        for flight in filteredInboundFlights {
            flight.checked = false
        }
        inboundFlight.checked = true
        
        guard routePrice != nil else { return }
        self.delegate?.didSelectInboundFlight()
    }
}

