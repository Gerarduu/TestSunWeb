//
//  MockAPI.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 07/03/2021.
//

import Foundation

class MockAPI {
    
    static let shared = MockAPI()
    
    func requestMockObject<T:Decodable>(route: String, completion: (@escaping (_: Result<T, Error>) -> Void)) {
        if let path = Bundle.main.path(forResource: route, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                if let result = try? JSONDecoder().decode(T.self, from: data) {
                    completion(Result.success(result))
                } else {
                    completion(Result.failure(AppError.generic))
                }
            } catch let err {
                debugPrint("Malformed data: \(err)")
            }
        }
    }
}
