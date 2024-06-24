//
//  UserChargingSessionModel.swift
//  EVApp
//
//  Created by VM on 23/06/24.
//

import Foundation

struct UserChargingSessionResponse: Decodable {
    let status: Bool?
    let userTrxSessions: [UserChargingSession]?
}

struct UserChargingSession: Decodable {
    let userTransactionId: Int?
    let amount: Float?
    let chargingStatus: String?
    let consumedUnits: Float?
    let consumableUnits: Float?
    let chargeboxId: String?
    let connectorId: String?
    let paymentTransactionId: Int?
    let startTime: String?
    let stopTime: String?
    let date: String?
    let totalTime: String?
    let stationName: String?
//    let chargerAddress: ChargerAddress?
    let idTag: String?
    let amountDebited: Float?
    let userPk: Int?
    let couponCode: String?
    let energyInWatts: Float?
    let timerBasedCharging: Bool?
    let chargingTimeInMinutes: Int?
    let totalTimeTakenInMinutes: Float?
    let totalTimeRemainingInMinutes: Float?
    let couponId: Int?
    let chargingCompleted: Bool?
}

//struct ChargerAddress: Decodable {
//    let street: String?
//    let houseNumber: String?
//    let zipCode: String?
//    let city: String?
//    let country: String?
//    let latitude: String?
//    let longitude: String?
//    let state: String?
//    let shortForm: String?
//    let billingAddress: String?
//    let operatingMode: String?
//    let gstNumber: String?
//    let chargerType: String?
//}
