//
//  ChargerList.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 27/05/23.
//

import Foundation

// MARK: - WelcomeElement
struct ChargerList: Decodable {
    let stationID, location: String
    let chargerInfos: [ChargerInfoList]
    let status: String

    enum CodingKeys: String, CodingKey {
        case stationID = "stationId"
        case location, chargerInfos, status
    }
}

// MARK: - ChargerInfo
struct ChargerInfoList: Decodable {
    let name: String?
enum CodingKeys: String, CodingKey {
    case name
    }
}

