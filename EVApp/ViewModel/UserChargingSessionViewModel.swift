//
//  UserChargingSessionViewModel.swift
//  EVApp
//
//  Created by VM on 23/06/24.
//

import Foundation
class UserChargingSessionViewModel{
    private var chargingRepo: ChargingRepo
    
    init(chargingRepo: ChargingRepo = ChargingRepo()) {
        self.chargingRepo = chargingRepo
    }
    
    func getAllUserChargingSessions(completion: @escaping ResultHandler<UserChargingSessionResponse>){
        let httpBody = ["userPk":UserAppStorage.userPk]
        chargingRepo.getUserChargingSessions(httpBody: httpBody, completion: completion)
    }
}
