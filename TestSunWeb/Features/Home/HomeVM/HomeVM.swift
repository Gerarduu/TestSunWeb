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
    
    init(delegate: HomeVMDelegate) {
        self.delegate = delegate
        self.flights = FlightManager.shared.getFlights()
    }
    
    func loadData() {
        /// If the App has already been opened previously, load the previously selected flights.
        if let alreadyLaunched = Preferences.getPrefsHasAlreadyLaunched(), alreadyLaunched {
            loadSelectedFlights()
        } else {
            /// If the App has been opened for the first time, select the cheapest route possible.
            if let cheapestFlight = self.outboundFlights.first {
                Preferences.setPrefsHasAlreadyLaunched(value: true)
                selectOutboundFlight(outboundFlight: cheapestFlight)
            }
        }
    }
    
    func loadSelectedFlights() {
        /// If we can get a previously selected flights, tell the VC that there are selected flights.
        if let outboundFlight = outboundFlights.first(where: {$0.checked == true}) {
            self.selectedOutboundFlight = outboundFlight
            delegate?.didSelectOutboundFlight()
            if let inboundFlight = filteredInboundFlights.first(where:{$0.checked == true}) {
                self.selectedInboundFlight = inboundFlight
                delegate?.didSelectInboundFlight()
            } else {
                delegate?.couldntSelectInboundFlight()
            }
        } else { /// If we cannot get a previously selected flights, select the cheapest ones.
            if let cheapestOutboundFlight = self.outboundFlights.first {
                selectOutboundFlight(outboundFlight: cheapestOutboundFlight)
            }
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
        
        self.delegate?.didSelectOutboundFlight()
        
        /// Select the cheapest inbound flight
        if let cheapestFlight = self.filteredInboundFlights.first {
            selectInboundFlight(inboundFlight: cheapestFlight)
        } else {
            self.delegate?.couldntSelectInboundFlight()
        }
    }
        
    func selectInboundFlight(inboundFlight:FlightObject) {
        
        self.selectedInboundFlight = inboundFlight
        
        for flight in filteredInboundFlights {
            flight.checked = false
        }
        inboundFlight.checked = true
        
        self.delegate?.didSelectInboundFlight()
    }
}

extension HomeVM {
    
    var filteredInboundFlights: [FlightObject]! {
        return inboundFlights.filter{$0.visible == true}
    }
    
    var routePrice: Float? {
        guard let selectedOutboundFlight = self.selectedOutboundFlight,
              selectedOutboundFlight.transportPrice >= 0,
              let selectedInboundFlight = self.selectedInboundFlight,
              selectedInboundFlight.transportPrice >= 0 else {
            return nil
        }
        return selectedInboundFlight.transportPrice + selectedOutboundFlight.transportPrice
    }
    
    var outboundFlights: [FlightObject]! {
        return self.flights?
            .filter{$0.outBound == 1}
            .sorted(by: {
                let first = $0.transportPrice, second = $1.transportPrice
                return first < second
            })
    }
    
    var inboundFlights: [FlightObject]! {
        return self.flights?
            .filter{$0.outBound == 0}
            .sorted(by: {
                let first = $0.transportPrice, second = $1.transportPrice
                return first < second
            })
    }
}
