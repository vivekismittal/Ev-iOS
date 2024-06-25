//
//  ChargingUnitViewModel.swift
//  EVApp
//
//  Created by VM on 20/06/24.
//

import Foundation
class ChargingUnitViewModel{
    private var chargingRepo = ChargingRepo()
    private var walletRepo = WalletRepo()
    

    
    init(chargingUnitRepo: ChargingRepo = ChargingRepo()) {
        self.chargingRepo = chargingUnitRepo
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
        chargingRepo.getChargingAmountBasedOnType(httpBody: httpBody,type: type,completion: completion)
    }
    
    func startCharging(connName: String, chargerBoxId: String, timeBasedCharging: Bool, chargingTimeInMinutes: Int, orderChargingAmount: Float, completion: @escaping ResultHandler<StartChargingModel>){
        let parameters: HttpBody = [
            "connectorId":connName,
            "idTag":"tag001",
            "chargeBoxIdentity":chargerBoxId,
            "amount":orderChargingAmount,
            "userPk":UserAppStorage.userPk,
            "paymentTransactionId": 0,
            "timerBasedCharging": timeBasedCharging,
            "chargingTimeInMinutes": chargingTimeInMinutes
        ]
        chargingRepo.startCharging(httpBody: parameters, completion: completion)
    }
    
    
}
