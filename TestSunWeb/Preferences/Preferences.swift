//
//  Preferences.swift
//  TestSunWeb
//
//  Created by Gerard Riera  on 09/03/2021.
//

import Foundation

class Preferences {
    static func getPrefsCached() -> Bool? {
        return UserDefaults.standard.bool(forKey: kCached)
    }

    static func setPrefsCached(value: Bool?) {
        UserDefaults.standard.set(value, forKey: kCached)
    }
}
