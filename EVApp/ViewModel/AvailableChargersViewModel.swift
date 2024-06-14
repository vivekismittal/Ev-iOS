//
//  AvailableChargerViewModel.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import Foundation

class AvailableChargersViewModel{
    private let availableChargersRepo: AvailableChargersRepo
    var availableChargingStations: [AvailableChargers]
    
    
    init(availableChargersRepo: AvailableChargersRepo, availableChargingStations: [AvailableChargers] = [AvailableChargers]()) {
        self.availableChargersRepo = availableChargersRepo
        self.availableChargingStations = availableChargingStations
    }
    
    func fetchSortedAvailableChargingStations(sorted: Bool = true, completionHandler: @escaping ResultHandler<Bool>) {
        availableChargersRepo.getAvailableChargingStations(){ [weak self] response  in
                switch response {
                case .success(let stations):
                    self?.availableChargingStations = stations
                    if sorted{
                        self?.sortChargingStationsByDistance()
                    }
                    completionHandler(.success(true))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            
        }
    }
    
    private func sortChargingStationsByDistance(){
        for var charger in self.availableChargingStations {
            if let address = charger.stationChargerAddress{
                let distance = LocationManager.shared.getDistance(from: address)
                charger.message = distance
            }
        }
        self.availableChargingStations.sort{ Float($0.message ?? "0") ?? 0 < Float($1.message ?? "0") ?? 0}
        
        
    }
}
