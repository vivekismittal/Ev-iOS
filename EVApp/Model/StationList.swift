//
//  StationList.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/06/23.
//

import Foundation

//struct StationList: Codable {
//    let id: Int
//    let title: String
//    let price: Double
//   
//}


// MARK: - WelcomeElement
struct StationList: Codable {
    let stationOpenForCharging: Bool
   // let totalConnectors: Int
 
  //  let avgRating: Double?
   // let stationTimings: String?
   // let publics, maintenance: Bool?
//    let status, location: String?
//    let stationChargerAddress: StationChargerAddress?
//    let availableConnectors: Int?
    let chargerInfos: [ChargerInfo]?

    enum CodingKeys: String, CodingKey {
        case stationOpenForCharging
        case chargerInfos
        //case avgRating, stationTimings, publics, maintenance, status, location, stationChargerAddress, availableConnectors, chargerInfos
    }
}

// MARK: - ChargerInfo
struct ChargerInfo: Codable {
  //  let status, chargePointVendor, chargePointModel: String?
    let occppProtocol: String?
   // let message, chargePointSerialNumber: String?
    let chargerStationConnectorInfos: [ChargerStationConnectorInfo]
    let chargerConnectorPrices: Int?
    let name: String
   
//    let chargeBoxPk: Int
//    let chargeBoxID: String
//    let chargerAddress: [String: String?]
//
//    enum CodingKeys: String, CodingKey {
//      //  case status, chargePointVendor, chargePointModel, occppProtocol, message, chargePointSerialNumber, chargerStationConnectorInfos, chargerConnectorPrices, name, chargerPointAmeneties, chargeBoxPk
//        case occppProtocol
//        case name, nchargerConnectorPrices
//    }
}
//
//// MARK: - ChargerPointAmeneties
//struct ChargerPointAmeneties: Codable {
//    let amenities: String?
//}
//
//// MARK: - ChargerStationConnectorInfo
struct ChargerStationConnectorInfo: Codable {
    let connectorType: String
    let id, chargeBoxPk: Int
//    let stationID, stationLocation: String
//    let parkingPrice: Int
   // let  chargeBoxID: String
//    let connectorID: String
    let available: Bool
//    let connectorNo, reason, startTime: String
    let chargerPrice: Int
//
//    enum CodingKeys: String, CodingKey {
//        case connectorType, id, chargeBoxPk
//        case stationID
//        case stationLocation, parkingPrice, endTime, location, stationStatus
//        case chargeBoxID
//        case connectorID
//        case available, connectorNo, reason, startTime, chargerPrice
//    }
 }
//
//// MARK: - StationChargerAddress
//struct StationChargerAddress: Codable {
//    let houseNumber: String?
//    let country: String
//    let street: String?
//    let state: String?
//    let city, latitude, longitude: String
//    let zipCode: String?
//}
//
////typealias StationList = [StationList]
//
//
