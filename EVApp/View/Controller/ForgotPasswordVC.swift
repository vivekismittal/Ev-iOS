//
//  ForgotPasswordVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON


class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var txtMobile: SkyFloatingLabelTextField!
    @IBOutlet weak var btnsendOtp: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnsendOtp.layer.cornerRadius = 12
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func secdOTP(_ sender: Any) {
        
        let mobileValid = txtMobile.text!.isPhoneNumber
        guard mobileValid else {
                  showAlert(title: "Alert", message: "Please Enter Valid Phone Number")
                   return
               }
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangPassOtpVC") as! ChangPassOtpVC
        nextViewController.mobileNo = txtMobile.text ?? "0"
        self.present(nextViewController, animated:true, completion:nil)
   
    }
 
  
}
