//
//  AvailableChargersRepo.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import Foundation

class AvailableChargersRepo{
    
    func getAvailableChargingStations(completionHandler: @escaping ResultHandler<[AvailableChargers]>) {
        NewNetworkManager.shared.request(endPointType: .getAvailableChargingStations, modelType: [AvailableChargers].self) { response in
            switch response {
            case .success(let stations):
                completionHandler(.success(stations))
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
