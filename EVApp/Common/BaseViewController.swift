//
//  BaseViewController.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/06/23.
//

import Foundation

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

    }
    
    func showAlertWithCancel(message: String, title: String = "Alert", alertAction: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
            if let getAction = alertAction {
                getAction()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(message: String, title: String = "Alert", alertAction: (()->())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if let getAction = alertAction {
                getAction()
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    /// Burnt Caramel Light 0xFFAC6D
    static let rentainanceGray = UIColor(rgb: 0x2C2C2C)
    
}


extension UIColor {
    /// Create a color from a RGB hex value
    /// - Parameters:
    ///   - rgb: RGB hex value (anything about 0xFFFFFF will be masked out and ignored)
    ///   - alpha: alpha value
    public convenience init(rgb: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

var vSpinner : UIView?

extension UIViewController {
    
    func showSpinner(onView view : UIView) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            view.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
