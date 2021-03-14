//
//  APIRouter.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation

enum APIRouter {
    
    static let baseURLString = kBaseURL + kVersion
    
    /// Flights
    case flights
    
    /// Airlines
    case airlines

    var method: String {
        switch self {
            case .flights, .airlines : return kHTTPMethodGet
        }
    }

    var queryItems: [URLQueryItem] {
        switch self {
            case .flights, .airlines:
                let parameters = [
                    URLQueryItem(name: "", value: "")
                ]
            return parameters
        }
    }

    var path: String {
        switch self {
            case .flights, .airlines: return kAirlines
        }
    }

    var headers: [String: String]? {
        var headers: [String: String] = [:]
        headers = ["Content-Type": "application/json", "Accept": "application/json"]
        
        return headers
    }

    func asURLRequest() -> URLRequest? {
        var components = URLComponents(string: APIRouter.baseURLString+path)
        components?.queryItems = queryItems
        
        guard let url = components?.url else {return nil}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
}
