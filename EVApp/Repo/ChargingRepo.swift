//
//  ChargingUnitRepo.swift
//  EVApp
//
//  Created by VM on 20/06/24.
//

import Foundation
class ChargingRepo{
    
    func getChargingAmountBasedOnType(httpBody: HttpRequestBody,type: StartChargingType,completion: @escaping ResultHandler<ChargingAmountModel>){
        
        let endpoint: ServerEndPointType = switch type {
        case .Power:
                .getChargingAmountBasedOnPower(httpBody)
        case .Amount:
                .getChargingAmountBasedOnAmount(httpBody)
        case .Time:
                .getChargingAmountBasedOnTime(httpBody)
        }
        
        NewNetworkManager.shared.request(endPointType: endpoint , modelType: ChargingAmountModel.self,completion: completion)
    }
    
    func getUserChargingSessions(httpBody: HttpRequestBody,completion: @escaping ResultHandler<UserChargingSessionResponse>){
        NewNetworkManager.shared.request(endPointType: .getUserChargingSessions(httpBody), modelType: UserChargingSessionResponse.self,completion: completion)
    }
    
    func startCharging(httpBody: HttpRequestBody, completion: @escaping ResultHandler<StartChargingModel>){
        NewNetworkManager.shared.request(endPointType: .startCharging(httpBody), modelType: StartChargingModel.self, completion: completion)
    }
    
    func getChargingMeterValue(requestBody: HttpRequestBody,completion: @escaping ResultHandler<ChargingMeterValuesModel>){
        NewNetworkManager.shared.request(endPointType: .getChargingMeterValues(requestBody), modelType: ChargingMeterValuesModel.self, completion: completion)
    }
    
    func stopCharging(requestBody: HttpRequestBody,completion: @escaping ResultHandler<EmptyModel>){
        NewNetworkManager.shared.request(endPointType: .stopCharging(requestBody), modelType: EmptyModel.self, completion: completion)
    }
    
    
    func getAvailableChargingSlots(requestBody: HttpRequestBody, completion: @escaping ResultHandler<AvailableChargerBookingSlots>){
        NewNetworkManager.shared.request(endPointType: .getAvailableChargerBookingSlots(requestBody), modelType: AvailableChargerBookingSlots.self, completion: completion)
    }
    
    func makeAdvanceCharging(requestBody: HttpRequestBody, completion: @escaping ResultHandler<StatusMessageResponse>){
        NewNetworkManager.shared.request(endPointType: .makeAdvancedChargingBooking(requestBody), modelType: StatusMessageResponse.self, completion: completion)
    }
    
    func getAdvancedChargingBookingSlotsForUser(requestBody: HttpRequestBody, forPage: BookedSlotPage, completion: @escaping ResultHandler<[AdvancedChargingBookedSlot]>){
        
        NewNetworkManager.shared.request(
            endPointType: forPage == .Upcoming ? .getAdvancedChargingBookedSlotsForUpcoming(requestBody) : .getAdvancedChargingBookedSlotsForCancelled(requestBody),
            modelType: [AdvancedChargingBookedSlot].self, completion: completion)
    }
    
    func cancelChargingBookedSlot(requestBody: HttpRequestBody, completion: @escaping ResultHandler<StatusMessageResponse>){
        NewNetworkManager.shared.request(endPointType: .cancelChargingBookedSlot(requestBody), modelType: StatusMessageResponse.self, completion: completion)
    }
}
