//
//  ChargingUnitViewModel.swift
//  EVApp
//
//  Created by VM on 20/06/24.
//

import Foundation
class ChargingUnitViewModel{
   private var chargingUnitRepo = ChargingRepo()
    private var walletRepo = WalletRepo()
    
    init(chargingUnitRepo: ChargingRepo = ChargingRepo()) {
        self.chargingUnitRepo = chargingUnitRepo
    }
    
    func getWalletAmount(completion: @escaping ResultHandler<Float>){
        walletRepo.getWalletBalance(completionHandler: completion)
    }
    
    func getChargingAmountBasedOnType(quantity: Int,type: StartChargingType,chargerBoxId: String,isCorporateUser: Bool,connectorName: String,completion: @escaping ResultHandler<ChargingAmountModel>){
        let quantityKey: String =  switch type {
        case .Power:
                "energyInWatts"
        case .Amount:
               "amount"
        case .Time:
                "timeInMinutes"
        }
        
        let httpBody: HttpBody = [
            quantityKey: quantity,
            "chargeboxId": chargerBoxId,
            "corporateUser": isCorporateUser,
            "corporateCode": "",
            "connectorId":connectorName
        ]
        chargingUnitRepo.getChargingAmountBasedOnType(httpBody: httpBody,type: type,completion: completion)
    }
}
