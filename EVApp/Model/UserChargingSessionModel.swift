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
    
//    enum CodingKeys: CodingKey {
//        case status
//        case userTrxSessions
//    }
//    
//    init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
////        self.status =  if let status = try container.decodeIfPresent(String.self, forKey: .status){
////            status == "true"
////        } else {
////            nil
////        }
//        self.userTrxSessions = try container.decodeIfPresent([UserChargingSession].self, forKey: .userTrxSessions)
//    }
}

struct UserChargingSession: Decodable {
    let userTransactionId: String?
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
    
    enum CodingKeys: CodingKey {
        case userTransactionId
        case amount
        case chargingStatus
        case consumedUnits
        case consumableUnits
        case chargeboxId
        case connectorId
        case paymentTransactionId
        case startTime
        case stopTime
        case date
        case totalTime
        case stationName
        case idTag
        case amountDebited
        case userPk
        case couponCode
        case energyInWatts
        case timerBasedCharging
        case chargingTimeInMinutes
        case totalTimeTakenInMinutes
        case totalTimeRemainingInMinutes
        case couponId
        case chargingCompleted
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let transactionId = try container.decodeIfPresent(Int.self, forKey: .userTransactionId){
            self.userTransactionId = String(transactionId)
        } else{
            self.userTransactionId = nil
        }
        self.amount = try container.decodeIfPresent(Float.self, forKey: .amount)
        self.chargingStatus = try container.decodeIfPresent(String.self, forKey: .chargingStatus)
        self.consumedUnits = try container.decodeIfPresent(Float.self, forKey: .consumedUnits)
        self.consumableUnits = try container.decodeIfPresent(Float.self, forKey: .consumableUnits)
        self.chargeboxId = try container.decodeIfPresent(String.self, forKey: .chargeboxId)
        self.connectorId = try container.decodeIfPresent(String.self, forKey: .connectorId)
        self.paymentTransactionId = try container.decodeIfPresent(Int.self, forKey: .paymentTransactionId)
        self.startTime = try container.decodeIfPresent(String.self, forKey: .startTime)
        self.stopTime = try container.decodeIfPresent(String.self, forKey: .stopTime)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
        self.totalTime = try container.decodeIfPresent(String.self, forKey: .totalTime)
        self.stationName = try container.decodeIfPresent(String.self, forKey: .stationName)
        self.idTag = try container.decodeIfPresent(String.self, forKey: .idTag)
        self.amountDebited = try container.decodeIfPresent(Float.self, forKey: .amountDebited)
        self.userPk = try container.decodeIfPresent(Int.self, forKey: .userPk)
        self.couponCode = try container.decodeIfPresent(String.self, forKey: .couponCode)
        self.energyInWatts = try container.decodeIfPresent(Float.self, forKey: .energyInWatts)
        self.timerBasedCharging = try container.decodeIfPresent(Bool.self, forKey: .timerBasedCharging)
        self.chargingTimeInMinutes = try container.decodeIfPresent(Int.self, forKey: .chargingTimeInMinutes)
        self.totalTimeTakenInMinutes = try container.decodeIfPresent(Float.self, forKey: .totalTimeTakenInMinutes)
        self.totalTimeRemainingInMinutes = try container.decodeIfPresent(Float.self, forKey: .totalTimeRemainingInMinutes)
        self.couponId = try container.decodeIfPresent(Int.self, forKey: .couponId)
        self.chargingCompleted = try container.decodeIfPresent(Bool.self, forKey: .chargingCompleted)
    }
}
