//
//  ViewControllerFactory.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import UIKit

class ViewControllerFactory<T: UIViewController> {
    
    static private func viewController(for typeOfVC: ViewControllerType) -> T {
        let metadata = typeOfVC.storyboardRepresentation()
        let sb = UIStoryboard(name: metadata.storyboardName.rawValue, bundle: metadata.bundle)
        let vc = sb.instantiateViewController(withIdentifier: metadata.storyboardId.rawValue)
        return vc as! T
    }
    
    static func instantiateAvailableChargersViewController() -> AvailableConnectorsVC{
        let availableChargerRepo = AvailableChargersRepo()
        let availableChargerViewModel = AvailableChargersViewModel(availableChargersRepo: availableChargerRepo)
        let availableChargerViewController =  ViewControllerFactory<AvailableConnectorsVC>.viewController(for: .AvailableCharger)
        availableChargerViewController.viewModel = availableChargerViewModel
        return availableChargerViewController
    }
    
    static func instantiateChargingDetailViewController() -> ChargingDetailVC{
        let chargingDetailVC = ViewControllerFactory<ChargingDetailVC>.viewController(for: .ChargingDetail)
        return chargingDetailVC
    }
    
    static func instantiateWelcomeViewController() -> WelcomeVC{
        let welcomeVC = ViewControllerFactory<WelcomeVC>.viewController(for: .WelcomeScreen)
        return welcomeVC
    }
}
