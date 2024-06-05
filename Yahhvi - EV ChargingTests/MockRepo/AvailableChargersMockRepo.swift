//
//  AvailableChargersMockRepo.swift
//  Yahhvi - EV ChargingTests
//
//  Created by VM on 03/06/24.
//
import Foundation
@testable import Yahhvi___EV_Charging
import XCTest

// Mock repository
class MockAvailableChargersRepo: AvailableChargersRepo {
    var shouldReturnError = false
    var mockStations: [AvailableChargers] = []

    func getAvailableChargingStations(completion: @escaping (Result<[AvailableChargers], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
        } else {
            completion(.success(mockStations))
        }
    }
}
