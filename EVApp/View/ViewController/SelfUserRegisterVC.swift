//
//  SelfUserRegisterVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/05/23.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class SelfUserRegisterVC: UIViewController {
    let countryDrop = DropDown()
    let stateDrop = DropDown()
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtCountry: SkyFloatingLabelTextField!
    @IBOutlet weak var txtState: SkyFloatingLabelTextField!
    @IBOutlet weak var txtFullName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var txtPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtReferalCode: SkyFloatingLabelTextField!
    @IBOutlet weak var txtEmail: SkyFloatingLabelTextField!
    @IBOutlet weak var toogleButtonImage: UIImageView!
    
    private var terms: Bool = false

    
    var stateNameList = [""]
    var countryNameList = [""]
    var stateCode = [""]
    var countryCode = [""]
    var sCode = ""
    var cCode = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setToggleImage()
        toogleButtonImage.isUserInteractionEnabled = true
        toogleButtonImage.setOnClickListener {[weak self] in
            self?.toggleButton()
        }
        callStateApi()
        callCountryApi()
        self.btnNext.layer.cornerRadius = 12
        
    }
    
    func toggleButton() {
          terms.toggle()
          setToggleImage()
     }
     
     private func setToggleImage(){
         if !terms {
             toogleButtonImage.image = #imageLiteral(resourceName: "square radio button black copy")
            
         } else {
             toogleButtonImage.image = UIImage(named: "square radio button green copy")
         }
     }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    @IBAction func tnc(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TemsConditionVC") as! TemsConditionVC
        nextViewController.reg =  true
        self.present(nextViewController, animated:true, completion:nil)
    }
    @IBAction func countryPressed(_ sender: Any) {
        
        countryDrop.anchorView = sender as? any AnchorView
        countryDrop.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        
        if txtCountry.isSelected {
            txtCountry.isSelected = true
            countryDrop.hide()
               }else {
                   txtCountry.isSelected = false
                   countryDrop.show()
                }
    }
    
    @IBAction func statePressed(_ sender: Any) {
        stateDrop.anchorView = sender as? any AnchorView
        stateDrop.bottomOffset = CGPoint(x: 0, y: (sender as AnyObject).frame.size.height)
        
        if txtState.isSelected {
            txtState.isSelected = true
            stateDrop.hide()
               }else {
                   txtState.isSelected = false
                   stateDrop.show()
                }
    }
    @IBAction func next(_ sender: Any) {
        
    let mobileValid = txtMobile.text!.isPhoneNumber
    let emailValid = txtEmail.text!.isValidEmail()
        let pass = txtPassword.text
        let cPass = txtConfirmPassword.text
    guard mobileValid else {
              showAlert(title: "Alert", message: "Please Enter Valid Phone Number")
               return
           }
    guard emailValid else {
              showAlert(title: "Alert", message: "Please Enter valid Email Id")
               return
           }
    guard pass != "" else {
                  showAlert(title: "Alert", message: "Password and Confirm Password can not be Empty!")
                   return
               }
    guard pass == cPass else {
                  showAlert(title: "Alert", message: "Password and Confirm Password Not Matched!")
                   return
               }
    guard terms == true else {
                      showAlert(title: "Alert", message: "Please select Terms and Conditions")
                       return
                   }
        self.callRegisterApi()

    }
    
    @IBAction func login(_ sender: Any) {
        let nextViewController = WelcomeVC.instantiateFromStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
        
        
    }
    func country(){
        print(stateNameList)
        countryDrop.dataSource = self.countryNameList
        countryDrop.selectionAction = { [unowned self] (index: Int, item: String) in
         // print("Selected item: \(item) at index: \(index)")
            self.cCode  = countryCode[index]
            self.txtCountry.text = item
        }
        countryDrop.width = txtCountry.frame.width
       // fresherDrop.direction = .bottom
        countryDrop.frame = txtCountry.frame

    }
    func state(){
       
        stateDrop.dataSource = self.stateNameList
        stateDrop.selectionAction = { [unowned self] (index: Int, item1: String) in
            print("Selected item: \(item1) at index: \(index)")
            self.sCode  = stateCode[index]
            self.txtState.text = item1
            
        }
        stateDrop.width = txtState.frame.width
       // fresherDrop.direction = .bottom
        stateDrop.frame = txtState.frame

    }
    func callStateApi(){
        let stateUrl = EndPoints.shared.baseUrl + EndPoints.shared.state
        let headers:HTTPHeaders = [
          
        ]
        LoadingOverlay.shared.showOverlay(view: view)
        AF.request(stateUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { [self]
                    response in
            LoadingOverlay.shared.hideOverlayView()

                    switch (response.result) {

                    case .success(let value):
                        print(response)
                        
                       let statusCode = response.response?.statusCode
                      print(statusCode)
                        
                let jsonData = JSON(value)
                        print(jsonData)
                    
                        let name = jsonData.arrayValue.map {$0["name"].stringValue}
                        let id = jsonData.arrayValue.map {$0["id"].intValue}
                        let code = jsonData.arrayValue.map {$0["code"].stringValue}
                        print(name)

                        self.stateNameList  = name
                        self.stateCode  = code
                        state()
                        
                        break
                    case .failure:
                        print(Error.self)
                       
                    }
                }
    }
    func callCountryApi(){
        let stateUrl = EndPoints.shared.baseUrl + EndPoints.shared.country
        let headers:HTTPHeaders = [
          
        ]
        LoadingOverlay.shared.showOverlay(view: view)
        AF.request(stateUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { [self]
                    response in
            LoadingOverlay.shared.hideOverlayView()

                    switch (response.result) {

                    case .success(let value):
                        print(response)
                        
                       let statusCode = response.response?.statusCode
                      print(statusCode)
                        
                let jsonData = JSON(value)
                        print(jsonData)
                    
                        let name = jsonData.arrayValue.map {$0["name"].stringValue}
                        let id = jsonData.arrayValue.map {$0["id"].intValue}
                        let code = jsonData.arrayValue.map {$0["code"].stringValue}
                        print(name)

                        self.countryNameList  = name
                        self.countryCode  = code
                        country()
                        
                        break
                    case .failure:
                        print(Error.self)
                       
                    }
                }
    }
    func callRegisterApi(){
        let loginUrl  = EndPoints.shared.baseUrl +  EndPoints.shared.registerUser
       // LoadingOverlay.shared.showOverlay(view: view)
        self.showSpinner(onView: view)
       
    let parameters = [
                "firstName": txtFullName.text!,
                "phone": txtMobile.text!,
                "eMail": txtEmail.text!,
                "password": txtPassword.text!,
                "stateId": self.sCode,
                "countryId": self.cCode
                    ] as? [String:AnyObject]
    print(parameters)
       
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
                            
                            guard status != "False" else {
                                self.showAlert(title: "Alert", message:message ?? "")
                                           return
                                       }
                            self.showToast(title: "", message: message ?? "")
                            let when = DispatchTime.now() + 2.0
                            DispatchQueue.main.asyncAfter(deadline: when){
                                if verified == false{
                                   // self.sendotpApi()
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "OTPVerifyVC") as! OTPVerifyVC
                                    nextViewController.mobile =  self.txtMobile.text!
                                    self.present(nextViewController, animated:true, completion:nil)
                                } else{
                                    self.gotoHome()
                                }
                            }
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
