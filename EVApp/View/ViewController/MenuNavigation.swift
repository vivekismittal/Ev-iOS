//
//  MenuNavigation.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 25/05/23.
//

import UIKit

class MenuNavigation: UINavigationController {
    
    static func instantiateFromStoryboard() -> Self {
        let menuNavigation = ViewControllerFactory<MenuNavigation>.viewController(for: .MenuNavigation)
        return menuNavigation as! Self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
