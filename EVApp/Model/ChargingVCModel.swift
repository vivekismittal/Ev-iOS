//
//  ChargingVCModel.swift
//  EVApp
//
//  Created by VM on 05/07/24.
//

import Foundation

class ChargingVCModel: Codable{
    let orderChargingUnitInWatt: Float
    let orderChargingAmount: Float
    let connectorName: String
    let chargerBoxId: String
    var userTransactionId: String?
    let timeBasedCharging: Bool
    let chargingTimeInMinutes: Int
    
    init(orderChargingUnitInWatt: Float, orderChargingAmount: Float, connectorName: String, chargerBoxId: String, userTransactionId: String? = nil, timeBasedCharging: Bool, chargingTimeInMinutes: Int) {
        self.orderChargingUnitInWatt = orderChargingUnitInWatt
        self.orderChargingAmount = orderChargingAmount
        self.connectorName = connectorName
        self.chargerBoxId = chargerBoxId
        self.userTransactionId = userTransactionId
        self.timeBasedCharging = timeBasedCharging
        self.chargingTimeInMinutes = chargingTimeInMinutes
    }
}
