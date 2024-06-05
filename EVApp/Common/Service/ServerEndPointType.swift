//
//  ProductEndPoint.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/07/23.
//

import Foundation

enum ServerEndPointType {
    case products // Module - GET
    // case addProduct(product: AddProduct) // POST
    case getAvailableChargingStations
    case getAppVersion
    
    func getUrlRequest() -> URLRequest? {
        guard let url else { return nil}
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters = body {
            request.httpBody = try? JSONEncoder().encode(parameters)
        }
        
        request.allHTTPHeaderFields = headers
        return request
    }
    
    
   private var path: String {
       return switch self {
        case .products:
             "chargers/stations"
            //        case .addProduct:
            //            return "products/add"
        case .getAvailableChargingStations:
             EndPoints.shared.chargersStations
       case .getAppVersion:
           EndPoints.shared.version
        }
    }
    
    private var baseURL: String {
       return  switch self {
         case .products:
              "http://beta.greenvelocity.co.in:8080/cms/manager/rest/"
             //        case .addProduct:
             //            return "https://dummyjson.com/"
             
         default:
              EndPoints.shared.baseUrlDev
         }
     }
     
     var url: URL? {
         return URL(string: "\(baseURL)\(path)")
     }
     
     var method: HTTPMethod {
        return switch self {
         case .products:
              .GET
         case .getAvailableChargingStations:
              .GET
        case .getAppVersion:
                .GET
         }
     }
     
     var body: Encodable? {
         return switch(self){
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
