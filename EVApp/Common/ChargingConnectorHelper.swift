//
//  ChargingSessionHelper.swift
//  EVApp
//
//  Created by VM on 16/06/24.
//

import UIKit

extension UIViewController{
    
    func connect(to chargerConnectorInfo: ChargerStationConnectorInfos, chargerInfoName: String?, streetAddress: String?){
        
        if UserAppStorage.isGuestUser{
            startGuestUserSignupFlow()
            return
        }
        
        switch chargerConnectorInfo.reason{
        case .Available:
            let nextViewController = ChargingStationVC.instantiateUsingStoryboard(with: chargerConnectorInfo, chargerInfoName: chargerInfoName ?? "", streetAddress: streetAddress ?? "")
            self.present(nextViewController, animated: true)
//            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        case .Charger_in_use:
            self.showToast(title: "Yahhvi", message: "Charger in use")
            
        case .Under_Maintenance:
            self.showToast(title: "Yahhvi", message: "Under Maintenance")
            
        case .unknown(_), .none:
            self.showToast(title: "Yahhvi", message: "Power Loss")
        }
    }
}
