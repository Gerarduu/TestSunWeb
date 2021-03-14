//
//  Airlines.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation

struct AirlinesRoot: Codable {
    var airlines: [Airline]?
}

struct Airline: Codable {
    var id: String?
    var name: String?
    var headline: String?
    var description: String?
    var logoImg: URL?
    var mainImg: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case headline = "headline"
        case description = "description"
        case logoImg = "logoImg"
        case mainImg = "mainImg"
    }
}
