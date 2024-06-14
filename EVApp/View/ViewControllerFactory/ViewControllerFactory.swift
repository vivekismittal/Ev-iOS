//
//  ViewControllerFactory.swift
//  EVApp
//
//  Created by VM on 02/06/24.
//

import UIKit

class ViewControllerFactory<T: UIViewController> {
    
    static func viewController(for typeOfVC: ViewControllerType) -> T {
        let metadata = typeOfVC.storyboardRepresentation()
        let sb = UIStoryboard(name: metadata.storyboardName.rawValue, bundle: metadata.bundle)
        let vc = sb.instantiateViewController(withIdentifier: metadata.storyboardId.rawValue)
        return vc as! T
    }
}

//MARK: Don't remove the below protocol as this is used to easy the define the instantiate methods on each view controllers and also for applying consistency

@objc protocol InstantiateViewController {
    @objc optional static func instantiateUsingStoryboard() -> Self
}

extension UIViewController: InstantiateViewController{}

