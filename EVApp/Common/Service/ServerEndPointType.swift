//
//  ProductEndPoint.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/07/23.
//

import Foundation

typealias HttpRequestBody = [String : Any?]

enum ServerEndPointType {
    case getAvailableChargingStations
    case getAppVersion
    case getWalletAmount(HttpRequestBody)
    case getChargingAmountBasedOnTime(HttpRequestBody)
    case getChargingAmountBasedOnPower(HttpRequestBody)
    case getChargingAmountBasedOnAmount(HttpRequestBody)
    case getUserChargingSessions(HttpRequestBody)
    case startCharging(HttpRequestBody)
    case getChargingMeterValues(HttpRequestBody)
    case stopCharging(HttpRequestBody)
    case getAvailableChargerBookingSlots(HttpRequestBody)
    case makeAdvancedChargingBooking(HttpRequestBody)
    case getAdvancedChargingBookedSlotsForUpcoming(HttpRequestBody)
    case getAdvancedChargingBookedSlotsForCancelled(HttpRequestBody)
    case cancelChargingBookedSlot(HttpRequestBody)
    
    private var path: String {
        return switch self {
        case .getAvailableChargingStations:
            EndPoints.shared.chargersStations
        case .getAppVersion:
            EndPoints.shared.version
        case .getWalletAmount:
            EndPoints.shared.getWalletAmount
        case .getChargingAmountBasedOnTime:
            EndPoints.shared.timeAmount
        case .getChargingAmountBasedOnPower:
            EndPoints.shared.wattAmount
        case .getChargingAmountBasedOnAmount:
            EndPoints.shared.amountUnit
        case .getUserChargingSessions:
            EndPoints.shared.paymentUsertrxsession
        case .startCharging:
            EndPoints.shared.trxStart
        case .getChargingMeterValues:
            EndPoints.shared.trxMeterValues
        case .stopCharging:
            EndPoints.shared.trxStop
        case .getAvailableChargerBookingSlots:
            EndPoints.shared.advancebookingTimeslots
        case .makeAdvancedChargingBooking:
            EndPoints.shared.advBookslots
        case .getAdvancedChargingBookedSlotsForUpcoming:
            EndPoints.shared.advbookingUserBookings
        case .cancelChargingBookedSlot:
            EndPoints.shared.adbookingCancelBooking
        case .getAdvancedChargingBookedSlotsForCancelled:
            EndPoints.shared.advbookingUserCancelled
        }
    }
    
    var method: HTTPMethod {
        return switch self {
        case .getAvailableChargingStations:
                .GET
        case .getAppVersion:
                .GET
        case .getWalletAmount:
                .POST
        case .getChargingAmountBasedOnTime:
                .POST
        case .getChargingAmountBasedOnPower:
                .POST
        case .getChargingAmountBasedOnAmount:
                .POST
        case .getUserChargingSessions:
                .POST
        case .startCharging:
                .POST
        case .getChargingMeterValues:
                .POST
        case .stopCharging:
                .POST
        case .getAvailableChargerBookingSlots:
                .POST
        case .makeAdvancedChargingBooking:
                .POST
        case .getAdvancedChargingBookedSlotsForUpcoming:
                .POST
        case .getAdvancedChargingBookedSlotsForCancelled:
                .POST
        case .cancelChargingBookedSlot:
                .POST
        }
    }
    
    var body: HttpRequestBody? {
        return switch(self){
        case .getAvailableChargingStations:
            nil
        case .getAppVersion:
            nil
            
        case .getWalletAmount(let body):
            body
        case .getChargingAmountBasedOnTime(let body):
            body
        case .getChargingAmountBasedOnPower(let body):
            body
        case .getChargingAmountBasedOnAmount(let body):
            body
        case .getUserChargingSessions(let body):
            body
        case .startCharging(let body):
            body
        case .getChargingMeterValues(let body):
            body
        case .stopCharging(let body):
            body
        case .getAvailableChargerBookingSlots(let body):
            body
        case .makeAdvancedChargingBooking(let body):
            body
        case .getAdvancedChargingBookedSlotsForUpcoming(let body):
            body
        case .getAdvancedChargingBookedSlotsForCancelled(let body):
            body
        case .cancelChargingBookedSlot(let body):
            body
        }
    }
    
    func getUrlRequest() -> URLRequest? {
        guard let url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        request.allHTTPHeaderFields = headers
        return request
    }
    
    private var baseURL: String {
        return  switch self {
        default:
            EndPoints.shared.baseUrlDev
        }
    }
    
    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }
    
    var headers: [String : String]? {
        commonHeaders
    }
    
    private var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
}
