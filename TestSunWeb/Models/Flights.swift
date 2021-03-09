//
//  Flights.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation

struct FlightsRoot: Codable {
    var data: Flights?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

struct Flights: Codable {
    var outboundFlights: [Flight]?
    var inboundFlights: [Flight]?
    
    enum CodingKeys: String, CodingKey {
        case outboundFlights = "outboundFlights"
        case inboundFlights = "inboundFlights"
    }
}

protocol Transport {
    var id: Int { get set }
    var price: Float { get set }
    func isConbinableWith(transport: Transport)
}

struct Flight: Codable, Transport {
    
    var id: Int
    var airline: String?
    var departureAirportCode: String?
    var arrivalAirportCode: String?
    var price: Float
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case airline = "airline"
        case departureAirportCode = "departureAirportCode"
        case arrivalAirportCode = "arrivalAirportCode"
        case price = "price"
    }
    
    func isConbinableWith(transport: Transport) {
        
    }
}
