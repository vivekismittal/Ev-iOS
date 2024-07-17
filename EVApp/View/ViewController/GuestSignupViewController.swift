//
//  GuestSignupViewController.swift
//  EVApp
//
//  Created by VM on 09/06/24.
//

import UIKit

class GuestSignupViewController: UIViewController {
    
    @IBOutlet weak var blurredDissmisableView: UIView!
    
    static func instantiateFromStoryboard() -> Self {
         let vc = ViewControllerFactory<GuestSignupViewController>.viewController(for: .SignupBottomSheetForGuest)
         return vc as! Self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        blurredDissmisableView.setOnClickListener {
            self.dismiss(animated: false)
        }
    }

    @IBAction func onSignup(_ sender: Any) {
        UserAppStorage.reset()
        let nextViewController = RegistrationVC.instantiateFromStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
}

extension UIViewController{
    
    func startGuestUserSignupFlow(){
        let guestSignup = GuestSignupViewController.instantiateFromStoryboard()
        guestSignup.modalPresentationStyle = .overFullScreen
        self.present(guestSignup, animated: false)
    }
}
