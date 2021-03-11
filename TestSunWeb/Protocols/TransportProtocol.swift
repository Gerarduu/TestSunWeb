//
//  TransportProtocol.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 10/03/2021.
//

protocol Transport {
    var transportId: Int { get set }
    var transportPrice: Float { get set }
    func isConbinableWith(transport: Transport) 
}
