//
//  AvailableChargerViewModel.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import Foundation

class AvailableChargersViewModel{
    static let shared = AvailableChargersViewModel()
    private let availableChargersRepo: AvailableChargersRepo
    var availableChargingStations: [AvailableChargers]
    
    
   private init(availableChargersRepo: AvailableChargersRepo = AvailableChargersRepo(), availableChargingStations: [AvailableChargers] = [AvailableChargers]()) {
        self.availableChargersRepo = availableChargersRepo
        self.availableChargingStations = availableChargingStations
    }
    
    func fetchSortedAvailableChargingStations(sorted: Bool = true, completionHandler: @escaping ResultHandler<Bool>) {
        if availableChargingStations.isEmpty{
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
        } else{
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                if sorted{
                    self?.sortChargingStationsByDistance()
                }
                completionHandler(.success(true))
            }
        }
    }
    
    private func sortChargingStationsByDistance(){
        self.availableChargingStations.sort{
            LocationManager.shared.getDistance(from: $0.stationChargerAddress ?? StationChargerAddress()) < LocationManager.shared.getDistance(from: $1.stationChargerAddress ?? StationChargerAddress())
        }
    }
}
