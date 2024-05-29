//
//  LoginManager.swift
//  Smart World
//
//  Created by Ajitabh Upadhyay on 05/11/22.
//

import Foundation

class AvailableChargerManager {
   static let shared = AvailableChargerManager()
    
    func chargerStationsRequest(request:String,success: @escaping (([AvailableChargers])-> Void), fail: @escaping (()-> Void)) {
        let stateUrl = EndPoints().baseUrlDev + EndPoints().chargersStations
        
        ServiceManager.shared.callService(urlString: stateUrl, method: .GET, body: request, sucess: {
            (response: [AvailableChargers]) in
            print(response)
            if response == nil {
                fail()
                
            }else{
                success(response)

            }
        }, fail: {
            fail()
        })
    }
    
    func versionAPIRequest(request:String,success: @escaping ((Version)-> Void), fail: @escaping (()-> Void)) {
        let stateUrl = EndPoints().baseUrlDev + EndPoints().version
        ServiceManager.shared.callVersionAPI(urlString: stateUrl, method: .GET, body: request, sucess: {
            (response: Version) in
            print(response)
            if response == nil {
                fail()
            }else{
                success(response)

            }
        }, fail: {
            fail()
        })
    }
}

struct Version: Decodable{
    var ios: String?
}
