//
//  StartChargingModel.swift
//  EVApp
//
//  Created by VM on 25/06/24.
//

import Foundation

struct StartChargingModel: Decodable{
    let userTransactionId: String?
    
    enum CodingKeys: CodingKey {
        case userTransactionId
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let transactionId = try container.decodeIfPresent(Int.self, forKey: .userTransactionId){
            self.userTransactionId = String(transactionId)
        } else{
            self.userTransactionId = nil
        }
    }
}
