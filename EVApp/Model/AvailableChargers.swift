//
//  AvailableChargers.swift
//  EVApp
//
//  Created by Anoop Upadhyay on 15/09/23.
//

import Foundation

struct AvailableChargers: Decodable{
    var stationId: String?
    var location: String?
    var avgRating: Double?
    var maintenance: Bool
    var publics: Bool
    var chargerInfos: [ChargerInformation]?
    var status: String?
    var message: String?
    var stationChargerAddress: StationChargerAddress?
    var stationTimings: String?
    var availableConnectors: Int?
    var totalConnectors: Int?
    var stationOpenForCharging: Bool
    
}

struct ChargerInformation: Decodable{
    var distance: String?
    var chargeBoxPK: Double?
    var chargeBoxId: String?
    var name: String?
    var occppProtocol: String?
    var chargePointModel: String?
    var chargePointVendor: String?
    var chargePointSerialNumber: String?
    var chargerAddress: ChargerAddress?
    var chargerConnectorPrices: String?
    var chargerPointAmeneties: ChargerPointAmeneties?
    var status: String?
    var message: String?
    var chargerStationConnectorInfos: [ChargerStationConnectorInfos]?
    
    
}

struct ChargerAddress: Codable{
    var street: String?
    var houseNumber: String?
    var zipCode: String?
    var city: String?
    var country: String?
    var latitude: String?
    var longitude: String?
    var state: String?
    var shortForm: String?
    var billingAddress: String?
    var operatingMode: String?
    var gstNumber: String?
    var chargerType: String?
}

struct ChargerPointAmeneties: Codable {
    var amenities: String?
}

struct ChargerStationConnectorInfos: Decodable {
    var stationId: String?
    var connectorId: String?
    var connectorNo: String?
    var connectorType: String?
    var location: String?
    var reason: ChargingConnectoreReason?
    var chargeBoxPk: Int?
    var id: Int?
    var chargeBoxId: String?
    var chargerPrice: Float?
    var parkingPrice: Int?
    var stationStatus: String?
    var stationLocation: String?
    var startTime: String?
    var endTime: String?
    var idTag: String?
    var available: Bool?
}

enum ChargingConnectoreReason:  Decodable {
    case Available, Charger_in_use, Under_Maintenance
    case unknown(value: String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let status = try? container.decode(String.self)
        switch status {
              case "Available": self = .Available
              case "Charger in use": self = .Charger_in_use
              case "UnderMaintenance": self = .Under_Maintenance
              default:
                 self = .unknown(value: status ?? "unknown")
          }
      }
}

struct StationChargerAddress: Codable{
    var street: String?
    var houseNumber: String?
    var zipCode: String?
    var city: String?
    var country: String?
    var latitude: String?
    var longitude: String?
    var state: String?
}



struct DummyDataParsing: Decodable {
    var stationId: String?
    var location: String?
    var avgRating: Float?
    var maintenance: Bool
    //var publics: Bool
}


