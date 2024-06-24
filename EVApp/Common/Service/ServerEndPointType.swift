//
//  ProductEndPoint.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/07/23.
//

import Foundation

typealias HttpBody = [String : Any?]

enum ServerEndPointType {
    case getAvailableChargingStations
    case getAppVersion
    case getWalletAmount(HttpBody)
    case getChargingAmountBasedOnTime(HttpBody)
    case getChargingAmountBasedOnPower(HttpBody)
    case getChargingAmountBasedOnAmount(HttpBody)
    case getUserChargingSessions(HttpBody)
    
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
        }
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
        }
    }
    
    var body: HttpBody? {
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
        default:
            nil
        }
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
