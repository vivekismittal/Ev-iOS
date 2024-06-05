//
//  ProfileVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import SkyFloatingLabelTextField


class ProfileVC: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var txtGst: SkyFloatingLabelTextField!
    @IBOutlet weak var txtVehicleReg: SkyFloatingLabelTextField!
    @IBOutlet weak var txtVehicleModel: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFullName: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.btnSave.layer.cornerRadius =  12
       
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserApi()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        updateUserApi()
    }
    func getUserApi(){
        let loginUrl  = EndPoints.shared.baseUrlDev +  EndPoints.shared.getUserByPhone
        LoadingOverlay.shared.showOverlay(view: view)
        let userMobile = UserDefaults.standard.string(forKey: "userMobile")
        let parameters = [
            "mobileNumber": userMobile
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
                let firstName = jsonData["firstName"].string
                let eMail = jsonData["eMail"].string
                let sex = jsonData["sex"].string
                let vehicleModel = jsonData["vehicleModel"].string
                let phone = jsonData["phone"].string
                let password = jsonData["password"].string
                let lastName = jsonData["lastName"].string
                let userPk = jsonData["userPk"].int
                let vehicleRegistrationNumber = jsonData["vehicleRegistrationNumber"].string
                
                let fullName = (firstName ?? "")  + (lastName ?? "")
                self.showToast(title: "", message: message ?? "")
                self.txtFullName.text = fullName
                self.txtVehicleReg.text = vehicleRegistrationNumber
                self.txtEmail.text = eMail
                self.txtMobile.text = phone
                self.txtVehicleModel.text = vehicleModel
                self.lblFullName.text = fullName
                UserDefaults.standard.set(fullName, forKey: "userFullName")
                UserDefaults.standard.set(userPk, forKey: "userPk")
              //  self.txtGst.text = vehicleModel

                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    func updateUserApi(){
        let loginUrl  = EndPoints.shared.baseUrlDev +  EndPoints.shared.usersUpdate
        LoadingOverlay.shared.showOverlay(view: view)
        let userMobile = UserDefaults.standard.string(forKey: "userMobile")
        let parameters = [
            "firstName": txtFullName.text!,
            "phone": txtMobile.text!,
            "eMail": txtEmail.text!,
            "vehicleModel": txtVehicleModel.text!,
            "vehicleRegistrationNumber": txtVehicleReg.text!
        ] as? [String:AnyObject]
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
                self.getUserApi()
                let status = jsonData["status"].string
                let message = jsonData["message"].string
                self.showToast(title: "", message: message ?? "")
//                let firstName = jsonData["firstName"].string
//                let eMail = jsonData["eMail"].string
//                let sex = jsonData["sex"].string
//                let vehicleModel = jsonData["vehicleModel"].string
//                let phone = jsonData["phone"].string
//                let password = jsonData["password"].string
//                let lastName = jsonData["lastName"].string
//                let userPk = jsonData["userPk"].string
//                let vehicleRegistrationNumber = jsonData["vehicleRegistrationNumber"].string
//
//                self.txtFullName.text = (firstName ?? "")  + (lastName ?? "")
//                self.txtVehicleReg.text = vehicleRegistrationNumber
//                self.txtEmail.text = eMail
//                self.txtMobile.text = phone
//                self.txtVehicleModel.text = vehicleModel
//                 self.txtGst.text = vehicleModel

                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
}
