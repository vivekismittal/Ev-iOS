//
//  UserDefaultsService.swift
//  EVApp
//
//  Created by VM on 09/06/24.
//

import Foundation


struct UserAppStorage{
    @Storage<Bool>(key: .didUserLoggedIn, defaultValue: false)
    static var didUserLoggedIn: Bool
    
    @Storage<String?>(key: .UNIT, defaultValue: nil)
    static var unit: String?
    
    @Storage<String?>(key: .AMOUNT, defaultValue: nil)
    static var amount: String?
    
    @Storage<Int?>(key: .userPk, defaultValue: nil)
    static var userPk: Int?
    
    @Storage<Int?>(key: .real_id, defaultValue: nil)
        static var realId: Int?
    
    @Storage<String?>(key: .chrgBoxId, defaultValue: nil)
    static var chrgBoxId: String?
    
    @Storage<Int?>(key: .requestedUnit, defaultValue: nil)
    static var requestedUnit: Int?
    
    @Storage<Double?>(key: .trackLocationsLong, defaultValue: nil)
    static var trackLocationsLong: Double?
    
    @Storage<Double?>(key: .trackLocationsLat, defaultValue: nil)
    static var trackLocationsLat: Double?
    
    @Storage<String?>(key: .userFullName, defaultValue: nil)
    static var userFullName: String?
    
    @Storage<String?>(key: .email, defaultValue: nil)
    static var email: String?
    
    @Storage<String?>(key: .userMobile, defaultValue: nil)
    static var userMobile: String?
    
    @Storage<Bool>(key: .isGuestUser, defaultValue: false)
    static var isGuestUser: Bool
    
    static func reset() {
        StorageKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
}
