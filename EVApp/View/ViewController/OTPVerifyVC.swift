//
//  OTPVerifyVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 16/05/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class OTPVerifyVC: UIViewController {

    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    
    var mobile = ""
    var resendTimer = Timer()
    var count = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.btnNext.layer.cornerRadius = 12
        sendotpApi()
    }
    
    @IBAction func resendOtp(_ sender: Any) {
        sendotpApi()
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resendTimer.invalidate()
    }
    
    @IBAction func next(_ sender: Any) {
        verifyotpApi()
    }
    
    @objc func update() {
        if(count > 0) {
            count = count - 1
            print(count)
            self.btnResend.setTitle(" Resend OTP in: \(count)", for: .normal)
        }
        else {
            self.resendTimer.invalidate()
            self.btnResend.isUserInteractionEnabled = true
            self.btnResend.setTitle("Resend OTP", for: .normal)
            self.count = 60
        }
    }
    
    @IBAction func onBack(_ sender: Any) {
        goBack()
    }
    
    func verifyotpApi(){
        let verifyOtp  = EndPoints.shared.baseUrl + EndPoints.shared.verifyOtp
        LoadingOverlay.shared.showOverlay(view: view)
            let parameters = [
                "mobileNumber": mobile,
                "otp": txtMobile.text!
                    ] as? [String:AnyObject]

        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
                            UserAppStorage.userMobile = self.mobile
                            
                            self.showToast(title: "", message: message ?? "")
                        print(message)
                            let when = DispatchTime.now() + 2.0
                         
                                DispatchQueue.main.asyncAfter(deadline: when){
                                    if message == "USer Verified"{
                                        
                                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AccountStatusVC") as! AccountStatusVC
                                        nextViewController.message = message ?? ""
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
        let sendOtpURL  = EndPoints.shared.baseUrl + EndPoints.shared.sendOtp
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "mobileNumber": mobile
                ] as? [String:AnyObject]
        print(parameters)
        AF.request(sendOtpURL, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
              print(status)
                            print(message)
                            if status == "True"{
                              
                                self.resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                               
                                                }
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
