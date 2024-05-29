//
//  ProductEndPoint.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/07/23.
//

import Foundation
enum ProductEndPoint {
    case products // Module - GET
   // case addProduct(product: AddProduct) // POST
}
extension ProductEndPoint: EndPointType {

    var path: String {
        switch self {
        case .products:
            return "chargers/stations"
//        case .addProduct:
//            return "products/add"
        }
    }

    var baseURL: String {
        switch self {
        case .products:
            return "http://beta.greenvelocity.co.in:8080/cms/manager/rest/"
//        case .addProduct:
//            return "https://dummyjson.com/"
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .products:
            return .get
//        case .addProduct:
//            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .products:
            return nil
//        case .addProduct(let product):
//            return product
        }
    }

    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
