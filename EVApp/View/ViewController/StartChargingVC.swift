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
    
//    var unit  = 0.0
    var connName = ""
    var chargerBoxId:String = ""
    var timeBasedCharging = false
    var chargingTimeInMinutes = 0
    var orderChargingAmount = Float()
    var orderChargingUnitInWatt = Float()

    static func instantiateUsingStoryboard() -> Self {
        let startChargingVC = ViewControllerFactory<Self>.viewController(for: .StartChargingScreen)
        return startChargingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnStartCharging.layer.cornerRadius = 12
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func startCharging(_ sender: Any) {
        callTrxStartApi()
    }
    
    func callTrxStartApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.trxStart
        let userPk = UserAppStorage.userPk
        // LoadingOverlay.shared.showOverlay(view: view)
        self.showSpinner(onView: view)
        
        let parameters = [
            "connectorId":connName,
            "idTag":"tag001",
            "chargeBoxIdentity":chargerBoxId,
            "amount":orderChargingAmount,
            "userPk":userPk,
            "paymentTransactionId": 0,
            "timerBasedCharging": timeBasedCharging,
            "chargingTimeInMinutes": chargingTimeInMinutes
        ] as? [String:AnyObject]
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
                
                let nextViewController = WaitingVC.instantiateUsingStoryboard()
//                nextViewController.orderAmount = Int(self.unit)
                nextViewController.connName = self.connName
                nextViewController.orderChargingAmount = self.orderChargingAmount
                nextViewController.orderChargingUnitInWatt = self.orderChargingUnitInWatt
                
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
