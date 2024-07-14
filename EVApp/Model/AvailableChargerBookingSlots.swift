//
//  AvailableChargerBookingSlots.swift
//  EVApp
//
//  Created by VM on 13/07/24.
//

import Foundation

struct AvailableChargerBookingSlots: Decodable{
    let bookingDates: [String]?
    
    enum CodingKeys: String, CodingKey {
        case bookingDates = "dates"
    }
}
