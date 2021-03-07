//
//  FakeSplashVM.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 06/03/2021.
//

import Foundation

protocol FakeSplashVMDelegate: class {
    func didLoadData(flights: Flights)
}

class FakeSplashVM {
    
    private weak var delegate: FakeSplashVMDelegate?
    private var flights: Flights?
    
    init(delegate: FakeSplashVMDelegate) {
        self.delegate = delegate
    }
    
    func loadData() {
        MockAPI.shared.requestMockObject(route: "flights") { [weak self] (result: Result<FlightsRoot,Error>) in
            guard let `self` = self else {return}
            switch result {
            case .failure(let err):
                debugPrint("error: \(err)")
                return
            case .success(let value):
                guard let data = value.data else {
                    return
                }
                self.delegate?.didLoadData(flights: data)
            }
        }
    }
}

extension FakeSplashVM {
    var flightsData: Flights? {
        guard let flights = self.flights else { return nil }
        return flights
    }
}
