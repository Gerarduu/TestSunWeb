//
//  FakeSplashVM.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import Foundation
import CoreData

protocol FakeSplashVMDelegate: class {
    func didLoadData()
    func error(error: Error)
}

class FakeSplashVM {
    
    private weak var delegate: FakeSplashVMDelegate?
    var outboundFlights = [Flight]()
    var inboundFlights = [Flight]()
    
    init(delegate: FakeSplashVMDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        MockAPI.shared.requestMockObject(route: "flights") { [weak self] (result: Result<FlightsRoot,Error>) in
            guard let `self` = self else {return}
            switch result {
            case .failure(let err):
                self.delegate?.error(error: err)
                return
            case .success(let value):
                guard let data = value.data,
                      let outboundFlights = data.outboundFlights,
                      outboundFlights.count > 0,
                      let inboundFlights = data.inboundFlights,
                      inboundFlights.count > 0 else {
                    self.delegate?.error(error: AppError.generic)
                    return
                }
                
                self.outboundFlights = outboundFlights
                self.inboundFlights = inboundFlights
                
                self.compareData { (outboundFlightsToSave, inboundFlightsToSave, flightsToDelete) in
                    for flight in flightsToDelete {
                        FlightManager.shared.deleteFlight(id: flight)
                    }
                    self.saveData(outboundFlightsToSave, inboundFlightsToSave)
                }
            }
        }
    }
    
    func compareData(finish: @escaping (_ outboundFlightsToSave: [Flight], _ inboundFlightsToSave: [Flight], _ flightsToDelete: [Int]) -> Void) {
        
        var outboundFlightsToSave = [Flight]()
        var inboundFlightsToSave = [Flight]()
        var flightsToDelete = [Int]()
        
        /// If we have saved flights, compare them with the flights retrieved from the API
        if let savedFlights = FlightManager.shared.getFlights(), savedFlights.count > 0 {
            let apiTransports = outboundFlights+inboundFlights
            let apiTransportsIds = Set(apiTransports.map({$0.transportId}))
            let savedTransportsIds = Set(savedFlights.map({$0.transportId}))
            /// If there is any difference between the flights retrieved from the API and the stored flights, get the different elements, and process them.
            if !savedTransportsIds.isSubset(of: apiTransportsIds) ||
                !apiTransportsIds.isSubset(of: savedTransportsIds) {
                let diff = savedTransportsIds.symmetricDifference(apiTransportsIds)
                for elem in diff {
                    ///If the element is from the API, but it doesn't exist in the local storage, add it to the local storage.
                    if !savedTransportsIds.contains(elem) && apiTransportsIds.contains(elem) {
                        if let flight = outboundFlights.filter({$0.transportId==elem}).first {
                            outboundFlightsToSave.append(flight)
                        } else if let flight = inboundFlights.filter({$0.transportId==elem}).first {
                            inboundFlightsToSave.append(flight)
                        }
                    /// If the element is in the local storage, but was removed from the API, remove it from the local storage.
                    } else if savedTransportsIds.contains(elem) && !apiTransportsIds.contains(elem) {
                        flightsToDelete.append(elem)
                    }
                }
                finish(outboundFlightsToSave, inboundFlightsToSave, flightsToDelete)
            } else {
                finish(outboundFlightsToSave, inboundFlightsToSave, flightsToDelete)
            }
        } else {
            finish(self.outboundFlights, self.inboundFlights, flightsToDelete)
        }
    }
    
    func saveData(_ outboundFlights: [Flight]?, _ inboundFlights: [Flight]?) {
        let group = DispatchGroup()
        
        group.enter()
        if let outboundFlights = outboundFlights, outboundFlights.count > 0 {
            FlightManager.shared.saveFlights(flights: outboundFlights, outBound: true) {
                group.leave()
            }
        } else {
            group.leave()
        }
        
        group.enter()
        if let inboundFlights = inboundFlights, inboundFlights.count > 0 {
            FlightManager.shared.saveFlights(flights: inboundFlights, outBound: false) {
                group.leave()
            }
        } else {
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.delegate?.didLoadData()
        }
    }
}
