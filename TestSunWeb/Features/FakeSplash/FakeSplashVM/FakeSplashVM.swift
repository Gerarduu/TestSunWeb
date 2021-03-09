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
    
    init(delegate: FakeSplashVMDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        if let cached = Preferences.getPrefsCached(), cached == true {
            self.delegate?.didLoadData()
        } else {
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
                    self.saveData(outboundFlights,inboundFlights)
                }
            }
        }
    }
    
    func saveData(_ outboundFlights: [Flight], _ inboundFlights: [Flight]) {
        
        let group = DispatchGroup()
        
        group.enter()
        FlightManager.shared.saveFlights(flights: outboundFlights, outBound: true) { [weak self] (result: Result<Bool,Error>) in
            switch result {
            case .failure(let err):
                self?.delegate?.error(error: err)
                return
            case .success:
                group.leave()
            }
        }
        
        group.enter()
        FlightManager.shared.saveFlights(flights: inboundFlights, outBound: false) { [weak self] (result: Result<Bool,Error>) in
            switch result {
            case .failure(let err):
                self?.delegate?.error(error: err)
                return
            case .success:
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            Preferences.setPrefsCached(value:true)
            self?.delegate?.didLoadData()
        }
    }
}


