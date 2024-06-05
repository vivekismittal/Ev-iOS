//
//  ChangPassOtpVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 25/06/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class ChangPassOtpVC: UIViewController {
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var txtOtp: SkyFloatingLabelTextField!
    
    var mobileNo = ""
    var count = 60
    var resendTimer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()

        sendotpApi()
        btnResend.isUserInteractionEnabled = false
        
    }
    
    @IBAction func back(_ sender: Any) {
    }
    
    @IBAction func resendOtp(_ sender: Any) {
      
        //resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        sendotpApi()
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
    func sendotpApi(){
        let sendOtpURL  = EndPoints.shared.baseUrlDev + EndPoints.shared.sendOtp
        LoadingOverlay.shared.showOverlay(view: view)
            let parameters = [
                "mobileNumber": mobileNo
                    ] as? [String:AnyObject]

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
                            print(message!)
        if status == "True"{
          
            self.resendTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
           
                            }
                          
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
    func verifyotpApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.verifyOtp
        LoadingOverlay.shared.showOverlay(view: view)
            let parameters = [
                "mobileNumber": mobileNo,
                "otp": txtOtp.text!
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
                          
                            print(message as Any)
                          //  let when = DispatchTime.now() + 2.0
                            if message == "USer Verified"{
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswwordVC") as! ChangePasswwordVC
                                nextVC.mobileNo = self.mobileNo
                                self.present(nextVC, animated:true, completion:nil)
                            }else{
                                self.showToast(title: "", message: message ?? "")
                            }
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
