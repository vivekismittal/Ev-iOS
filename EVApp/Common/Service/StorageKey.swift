//
//  UserDefaultsKey.swift
//  EVApp
//
//  Created by VM on 09/06/24.
//

import Foundation
enum StorageKey: String,CaseIterable{
    case didUserLoggedIn
    case UNIT
    case AMOUNT
    case userPk
    case chrgBoxId
    case requestedUnit
    case trackLocationsLong
    case trackLocationsLat
    case userFullName
    case email
    case userMobile
    case isGuestUser
    case real_id
}

@propertyWrapper
struct Storage<T> {
    private let key: String
    private let defaultValue: T
    
    init(key: StorageKey, defaultValue: T) {
        self.key = key.rawValue
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return (UserDefaults.standard.value(forKey: key) as? T) ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
