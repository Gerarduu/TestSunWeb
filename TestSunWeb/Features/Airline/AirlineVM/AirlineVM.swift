//
//  File.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 14/03/2021.
//

import Foundation

protocol AirlineVMDelegate: class {
    func didLoadData()
    func error(error: Error)
}

class AirlineVM {
    
    weak var delegate: AirlineVMDelegate?
    private var airline: AirlineObject?
    private var airlineId: String!
    
    init(delegate: AirlineVMDelegate, airlineId: String) {
        self.airlineId = airlineId
        self.delegate = delegate
    }
    
    func loadData() {
        if let airline = AirlineManager.shared.getAirline(id: self.airlineId) {
            self.airline = airline
            delegate?.didLoadData()
        } else {
            delegate?.error(error: AppError.generic)
        }
    }
}

extension AirlineVM {
    var id:String? {
        return self.airline?.id
    }
    var name:String? {
        return self.airline?.name
    }
    var headline:String? {
        return self.airline?.headline
    }
    var description:String? {
        return self.airline?.airlineDesc
    }
    var logoImg: URL? {
        return self.airline?.logoImg
    }
    var mainImg:URL? {
        return self.airline?.mainImg
    }
}
