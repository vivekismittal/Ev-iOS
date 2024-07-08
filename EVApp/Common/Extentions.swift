//
//  Extentions.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 18/05/23.
//

import Foundation
import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIViewController{
    
    func goBack(){
        guard let navigationController else {
            self.dismiss(animated: true)
            return
        }
        navigationController.popViewController(animated: true)
    }
    
    func gotoHome(){
        let landingScreen = MenuNavigation.instantiateUsingStoryboard()
        UIApplication.shared.windows.first?.rootViewController = landingScreen
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

               // add an action (button)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

               // show the alert
            self.present(alert, animated: true, completion: nil)
       
    }
    
    func showAlertController( titleOfAlert: String, messageOfAlert : String, doAction : () )
    {
        let refreshAlert = UIAlertController(title: titleOfAlert, message: messageOfAlert, preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
    ()
        }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)
    }
    func  showToast(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          // your code with delay
          alert.dismiss(animated: true, completion: nil)
        }
    }
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 18
        view.center = self.view.center
        view.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    func checkUpdateVersion(viewController: UIViewController){
  
        OnAppStartViewModel.shared.versionAPIRequest { res in
            switch res{
            case .success(let version):

                guard let response = version.ios, let responseVersion = Float(response) else {
                    return
                }
                
                if (UIApplication.shared.delegate as! AppDelegate).currentVersion < responseVersion {
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(
                            title: "Update Required",
                            message: "We have launched new app and improved app. Please update to continue using the app.",
                            preferredStyle: .alert)
                        
                        // Handling OK action
                        guard let url = URL(string: EndPoints.shared.appStoreLink) else { return }
                        
                        let okAction = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction!) in
                            UIApplication.shared.open(url)
                        }
                        // Adding action buttons to the alert controller
                        alertController.addAction(okAction)
                        viewController.present(alertController, animated: true, completion:nil)
                    }
                }
            case .failure(_):
                print("Failed to get response")
            }
        }
    }
}

extension Array {
    func element(at index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


class ClickListener: UITapGestureRecognizer {
    var onClick : (() -> Void)? = nil
}

extension UIView {
    
    func setOnClickListener(action :@escaping () -> Void){
        let tapRecogniser = ClickListener(target: self, action: #selector(onViewClicked(sender:)))
        tapRecogniser.onClick = action
        self.addGestureRecognizer(tapRecogniser)
    }
    
    @objc private func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }
    
}
