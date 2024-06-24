//
//  ChargingUnitRepo.swift
//  EVApp
//
//  Created by VM on 20/06/24.
//

import Foundation
class ChargingRepo{
    
    func getChargingAmountBasedOnType(httpBody: HttpBody,type: StartChargingType,completion: @escaping ResultHandler<ChargingAmountModel>){
        
        let endpoint: ServerEndPointType =  switch type {
        case .Power:
                .getChargingAmountBasedOnPower(httpBody)
        case .Amount:
                .getChargingAmountBasedOnAmount(httpBody)
        case .Time:
                .getChargingAmountBasedOnTime(httpBody)
        }
        
        NewNetworkManager.shared.request(endPointType: endpoint , modelType: ChargingAmountModel.self,completion: completion)
    }
    
    func getUserChargingSessions(httpBody: HttpBody,completion: @escaping ResultHandler<UserChargingSessionResponse>){
        NewNetworkManager.shared.request(endPointType: .getUserChargingSessions(httpBody), modelType: UserChargingSessionResponse.self,completion: completion)
    }
    
}
