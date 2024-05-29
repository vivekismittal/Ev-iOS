//
//  StartChargingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 12/06/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class StartChargingVC: UIViewController {

    @IBOutlet weak var btnStartCharging: UIButton!
    
    var unit  = 0.0
    var connName = ""
    var chargerBoxId:String = ""
    var timeBasedCharging = false
    var chargingTimeInMinutes = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnStartCharging.layer.cornerRadius = 12
    }
    
    @IBAction func back(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingUnitVC") as! ChargingUnitVC
//        self.present(nextViewController, animated:true, completion:nil)
        self.dismiss(animated: true)
    }
    @IBAction func startCharging(_ sender: Any) {
       callTrxStartApi()
    }
    
func callTrxStartApi(){
    let verifyOtp  = EndPoints().baseUrlDev + EndPoints().trxStart
    let userPk = UserDefaults.standard.integer(forKey: "userPk")
   var chrBoxId =  UserDefaults.standard.string(forKey: "chrgBoxId")
    let orderAmt =  UserDefaults.standard.string(forKey: "AMOUNT")
   // LoadingOverlay.shared.showOverlay(view: view)
    self.showSpinner(onView: view)
    
        let parameters = [
            "connectorId":connName,
            "idTag":"tag001",
            "chargeBoxIdentity":chargerBoxId,
            "amount":orderAmt,
            "userPk":userPk,
            "paymentTransactionId": 0,
            "timerBasedCharging": timeBasedCharging,
            "chargingTimeInMinutes": chargingTimeInMinutes
                ] as? [String:AnyObject]
    print(parameters)
    AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
                        
                        let userTransactionId = jsonData["userTransactionId"].intValue
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WaitingVC") as! WaitingVC
                        nextViewController.orderAmount = Int(self.unit)
                        nextViewController.connName = self.connName
                        
                        nextViewController.chargerBoxId = self.chargerBoxId
                        nextViewController.userTransactionId = userTransactionId
                        self.present(nextViewController, animated:true, completion:nil)
//                        let status = jsonData["status"].bool
//                        let amount = jsonData["amount"].floatValue
//                        let userWalletAccountId = jsonData["userWalletAccountId"].double
//                        self.lblWaletAmt.text = "Rs.: " + String(amount ?? 0)
//                        self.waletAmount = amount
                  
                        break
                    case .failure:
                        print(Error.self)
                       
                    }
                }
}

}
