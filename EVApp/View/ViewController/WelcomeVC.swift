//
//  WelcomeVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/05/23.
//

import UIKit
import SkyFloatingLabelTextField
import SideMenuSwift
import Alamofire
import SwiftyJSON

class WelcomeVC: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var userIdView: UIView!
    
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordView: UIView!
    
    static func instantiateUsingStoryboard() -> Self {
         let welcomeVC = ViewControllerFactory<WelcomeVC>.viewController(for: .WelcomeScreen)
         return welcomeVC as! Self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.btnNext.layer.cornerRadius = 12
    }
    
    @IBAction func next(_ sender: Any) {
        let mobileValid = txtMobile.text!.isPhoneNumber
        let pass = txtPassword.text
        guard mobileValid else {
                  showAlert(title: "Alert", message: "Please Enter Valid Phone Number")
                   return
               }

        guard pass != "" else {
                showAlert(title: "Alert", message: "Password can not be Empty!")
                       return
                   }
            self.callLoginApi()

    }
  
    @IBAction func forgotPassword(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.present(nextViewController, animated:true, completion:nil)
        //self.navigationController?.pushViewController(nextViewController, animated: false)
    }
    @IBAction func createAccount(_ sender: Any) {
        let nextViewController = RegistrationVC.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func guestButtonAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "GuestUserVC") as! GuestUserVC
        self.present(nextViewController, animated:true, completion:nil)
    }
    
//    func showAlert(title:String,message:String){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
//
//               // add an action (button)
//               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//
//               // show the alert
//            self.present(alert, animated: true, completion: nil)
//
//    }
//
    
    
    func callLoginApi(){
        let loginUrl  = EndPoints.shared.baseUrl +  EndPoints.shared.login
       // LoadingOverlay.shared.showOverlay(view: view)
        self.showSpinner(onView: view)
            let parameters = [
                "mobileNumber": txtMobile.text!,
                "password": txtPassword.text!
                    ] as? [String:AnyObject]
//        let parameters = [
//            "mobileNumber": "9871707578",
//            "password": "Test@123"
//                ] as? [String:AnyObject]
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
                LoadingOverlay.shared.hideOverlayView()
            self.removeSpinner()
                        switch (response.result) {

                        case .success(let value):
                            print(response)
                            
                    let statusCode = response.response?.statusCode
                            print(statusCode!)
                            
                    let jsonData = JSON(value)
                            print(jsonData)
                           
                            let status = jsonData["status"].string
                            let message = jsonData["message"].string
                            let verified = jsonData["verified"].bool
                            print(status)
                            self.showToast(title: "", message: message ?? "")
                            if status == "True"{
                                UserAppStorage.userMobile = self.txtMobile.text
                                let when = DispatchTime.now() + 2
                                DispatchQueue.main.asyncAfter(deadline: when){
                                    if verified == false{
                                        self.sendotpApi()
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                        nextViewController.mobile =  self.txtMobile.text!
                                        self.present(nextViewController, animated:true, completion:nil)
                                    } else{
                                        UserAppStorage.didUserLoggedIn = true
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigationPoint") as! MenuNavigation
                                        self.present(nextViewController, animated:true, completion:nil)
                                    }
                                }
                            }
                         
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
    
    func sendotpApi(){
        let guestURL  = EndPoints.shared.sendOtp
       // LoadingOverlay.shared.showOverlay(view: view)
        self.showSpinner(onView: view)
       
            let parameters = [
                "mobileNumber": txtMobile.text!
                    ] as? [String:AnyObject]
        AF.request(guestURL, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
              //  LoadingOverlay.shared.hideOverlayView()
          
            self.removeSpinner()
                        switch (response.result) {

                        case .success(let value):
                            print(response)
                            
                    let statusCode = response.response?.statusCode
                            print(statusCode!)
                            
                    let jsonData = JSON(value)
                            print(jsonData)
                           
                            let status = jsonData["status"].string
                            let message = jsonData["message"].string
                            let verified = jsonData["verified"].bool
              print(message)
                          
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    var isAdharNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count && self.count == 12
            } else {
                return false
            }
        } catch {
            return false
        }
    }

}
