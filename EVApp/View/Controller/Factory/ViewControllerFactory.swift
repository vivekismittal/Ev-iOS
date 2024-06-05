//
//  ViewControllerFactory.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import Foundation
import UIKit

class ViewControllerFactory {
    
    static private func viewController(for typeOfVC: ViewControllerType) -> UIViewController {
        let metadata = typeOfVC.storyboardRepresentation()
        let sb = UIStoryboard(name: metadata.storyboardName.rawValue, bundle: metadata.bundle)
        let vc = sb.instantiateViewController(withIdentifier: metadata.storyboardId.rawValue)
        return vc
    }
    
    static func instantiateAvailableChargersViewController() -> AvailableConnectorsVC{
        let availableChargerRepo = AvailableChargersRepo()
        let availableChargerViewModel = AvailableChargersViewModel(availableChargersRepo: availableChargerRepo)
        let availableChargerViewController =  ViewControllerFactory.viewController(for: .AvailableCharger) as! AvailableConnectorsVC
        availableChargerViewController.viewModel = availableChargerViewModel
        return availableChargerViewController
    }
    
    static func instantiateChargingDetailViewController() -> ChargingDetailVC{
        let chargingDetailVC = ViewControllerFactory.viewController(for: .ChargingDetail)
        return chargingDetailVC as! ChargingDetailVC
    }
}
