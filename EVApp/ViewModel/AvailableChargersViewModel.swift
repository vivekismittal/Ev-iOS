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
    
    
    func fetchSortedAvailableChargingStations(completionHandler: @escaping ResultHandler<Bool>) {
        
        availableChargersRepo.getAvailableChargingStations(){ [weak self] response  in
                switch response {
                case .success(let stations):
                    self?.availableChargingStations = stations
                    self?.sortChargingStationsByDistance {
                        completionHandler(.success(true))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            
        }
    }
    
    func sortChargingStationsByDistance(completionHandler: @escaping ()->Void){
        DispatchQueue.global(qos: .userInitiated).async {[weak self] in
            guard let `self` = self else { return }
            
            for var charger in self.availableChargingStations {
            if let address = charger.stationChargerAddress{
                let distance = LocationManager.shared.getDistance(from: address)
                charger.message = distance
            }//.chargerInfos?[0].distance = distance
        }
        //      let sorted =  availableChargers?.sorted(by: { $0.message ?? "" < $1.message ?? ""})
        //        for index in 0...((availableChargers?.count ?? 0) - 1){
        //            print("sorted distance --- \(availableChargers?[index].message ?? "failed")")
        //        }
        
            self.availableChargingStations.sort{ Float($0.message ?? "0") ?? 0 < Float($1.message ?? "0") ?? 0}
            completionHandler()
        }
    }
    
//    func getStationIDIndex(stationID: String) -> Int{
//        for (index,charger) in availableChargingStations.enumerated() {
//            if charger.stationId == stationID {
//                return index
//            }
//        }
//        return 0
//    }
    
//    func sortChargingStationsByDistance(){
////        lock.lock()
////        for i in stride(from: (availableChargers?.count ?? 1)-1, to: 0, by: -1) {
////            for j in 1...i {
////                if Float(availableChargers?[j-1].message ?? "0") ?? 0 > Float(availableChargers?[j].message ?? "0") ?? 0 {
////                    let tmp = availableChargers?[j-1]
////                    let currentValue = availableChargers?[j]
////                    availableChargers?[j-1] = currentValue! //availableChargers![j]
////                    availableChargers?[j] = tmp!
////                }
////            }
////        }
////        lock.unlock()
////        for charger in availableChargers{
////            print("sorted distance --- \(charger.message ?? "failed")")
////        }
//    }
}
