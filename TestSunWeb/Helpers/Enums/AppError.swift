//
//  AppError.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

enum AppError: Error {
    case message(String)
    case generic
    case malformedData
    
    public var errorDescription: String? {
        switch self {
        case .message(let message): return message
        case .generic: return "Error"
        default: return ""
        }
    }
}
