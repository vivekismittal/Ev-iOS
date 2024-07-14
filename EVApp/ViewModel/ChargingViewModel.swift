//
//  ChargingUnitViewModel.swift
//  EVApp
//
//  Created by VM on 20/06/24.
//

import Foundation
class ChargingViewModel{
    
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
        
        let httpBody: HttpRequestBody = [
            quantityKey: quantity,
            "chargeboxId": chargerBoxId,
            "corporateUser": isCorporateUser,
            "corporateCode": "",
            "connectorId":connectorName
        ]
        chargingRepo.getChargingAmountBasedOnType(httpBody: httpBody,type: type,completion: completion)
    }
    
    func startCharging(connName: String, chargerBoxId: String, timeBasedCharging: Bool, chargingTimeInMinutes: Int, orderChargingAmount: Float, completion: @escaping ResultHandler<StartChargingModel>){
        let parameters: HttpRequestBody = [
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
    
    func getMeterValuesUpdate(transactionId: String, connectorName: String, chargerBoxId: String, completion: @escaping ResultHandler<ChargingMeterValuesModel>){
        
        let requestBody: HttpRequestBody = [
            "userTransactionId": transactionId,
            "chargeBoxIdentity": chargerBoxId,
            "connectorId":  connectorName,
            "idTag":"user001"
        ]
        chargingRepo.getChargingMeterValue(requestBody: requestBody, completion: completion)
    }
    
    func stopCharging(userTransactionId: String,chargerBoxId: String,completion: @escaping ResultHandler<EmptyModel>){
        let requestBody: HttpRequestBody = [
            "userTransactionId":userTransactionId,
            "chargeBoxIdentity":chargerBoxId
        ]
        chargingRepo.stopCharging(requestBody: requestBody, completion: completion)
    }
    
    func getChargerBookingSlots(chargeBoxId: String, completion: @escaping ResultHandler<AvailableChargerBookingSlots>){
        let requestBody: HttpRequestBody = [
            "chargeBoxIdentity": chargeBoxId
        ]
        
        chargingRepo.getAvailableChargingSlots(requestBody: requestBody, completion: completion)
    }
    
    func makeAdvanceBookingForCharging(for date: String, startingTime: String, endingTime: String, connectorName: String, chargeBoxId: String, completion: @escaping ResultHandler<AdvanceBookingResponse>){
        let requestBody: HttpRequestBody = [
            "userId": UserAppStorage.userPk,
            "startTime": startingTime,
            "endTime": endingTime,
            "bookingDate": date,
            "bookingAmount": 150,
            "connectorId": connectorName,
            "idTag": "tag001",
            "chargeBoxIdentity": chargeBoxId
        ]
        
        chargingRepo.makeAdvanceCharging(requestBody: requestBody, completion: completion)
    }
}
