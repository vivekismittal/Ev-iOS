//
//  ChangePasswwordVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/06/23.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown
import Alamofire
import SwiftyJSON

class ChangePasswwordVC: UIViewController {

    @IBOutlet weak var btnChangePass: UIButton!
    @IBOutlet weak var txtNeewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirm: SkyFloatingLabelTextField!
    var mobileNo = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnChangePass.layer.cornerRadius = 12

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func changePassword(_ sender: Any) {
        let pass = txtNeewPassword.text
        let cPass = txtConfirm.text
        guard pass != "" else {
                      showAlert(title: "Alert", message: "Password and Confirm Password can not be Empty!")
                       return
                   }
        guard pass == cPass else {
                      showAlert(title: "Alert", message: "Password and Confirm Password Not Matched!")
                       return
                   }
        changePassApi()
    }
    
    func changePassApi(){
        let loginUrl  = EndPoints().baseUrl +  EndPoints().usersChangePassword
      //  let userMobile = UserDefaults.standard.string(forKey: "userMobile")
        LoadingOverlay.shared.showOverlay(view: view)
    let parameters = [
                "mobileNumber": mobileNo,
                "password": self.txtNeewPassword.text!,
                    ] as? [String:AnyObject]
    print(parameters)
       
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
                                   // self.sendotpApi()
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
                                   // nextViewController.mobile =  self.txtMobile.text!
                                    self.present(nextViewController, animated:true, completion:nil)
                                }
                            }
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }

}
