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
        }
    }
    
    var body: HttpRequestBody? {
        return switch(self){
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
        default:
            nil
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
