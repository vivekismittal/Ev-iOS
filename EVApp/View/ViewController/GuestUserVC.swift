//
//  GuestUserVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class GuestUserVC: UIViewController {
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    let phone = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnNext.layer.cornerRadius = 12
       
    }
    
    @IBAction func next(_ sender: Any) {
        if txtMobile.text == ""{
        showAlert(title: "Alert", message: "Mobile number is empty")
        }else if txtName.text == ""{
            showAlert(title: "Alert", message: "Name is empty")
        }else{
            callGuestApi()
        }
     
       
    }
    
    @IBAction func termsAction(_ sender: Any) {
        if btnTerms.isSelected {
            btnTerms.isSelected = false
            btnTerms.setImage(#imageLiteral(resourceName: "square radio button black copy"), for: .normal)
               }else {
                   btnTerms.isSelected = true
                   btnTerms.setImage(#imageLiteral(resourceName: "square radio button green copy"), for: .normal)
                }
    }
    func callGuestApi(){
        let guestURL  = EndPoints.shared.baseUrl +  EndPoints.shared.guestUser
        LoadingOverlay.shared.showOverlay(view: view)
            let parameters = [
                "firstName": txtName.text!,
                "phone": txtMobile.text!
                    ] as? [String:AnyObject]

        AF.request(guestURL, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
                LoadingOverlay.shared.hideOverlayView()

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
                            self.showToast(title: "", message: message ?? "")
                            let when = DispatchTime.now() + 2.0
                            DispatchQueue.main.asyncAfter(deadline: when){
                                if verified == false{
                                    self.sendotpApi()
                                    UserAppStorage.isGuestUser = true
                                    
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                    nextViewController.mobile =  self.txtMobile.text!
                                    self.present(nextViewController, animated:true, completion:nil)
                                }else{
                                    
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigationPoint") as! MenuNavigation
                                    self.present(nextViewController, animated:true, completion:nil)
                                }
                            }
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
    
    func sendotpApi(){
        let guestURL  = EndPoints.shared.baseUrl + EndPoints.shared.sendOtp
        LoadingOverlay.shared.showOverlay(view: view)
            let parameters = [
                "mobileNumber": txtMobile.text!
                    ] as? [String:AnyObject]

        AF.request(guestURL, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
                LoadingOverlay.shared.hideOverlayView()

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
