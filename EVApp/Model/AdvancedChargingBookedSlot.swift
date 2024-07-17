//
//  AdvancedChargingBookedSlots.swift
//  EVApp
//
//  Created by VM on 16/07/24.
//

import Foundation

struct AdvancedChargingBookedSlot: Decodable {
    let id: Int?
    let startTime, endTime, bookingDate: String?
    let bookingAmount: Int?
    let bookingCancelled: Bool?
    let userId: Int?
    //    let paymentTransactionId: String?
    let connectorId, chargeBoxIdentity, idTag: String?
    let chargerInfo: ChargerInformation?
    let chargingInitiated: Bool?
    let advanceBookingFineAmount: Int?
}
