//
//  ChargingUnitVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 30/05/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class ChargingUnitVC: UIViewController {
    @IBOutlet weak var imgConnectorType: UIImageView!
    @IBOutlet weak var lblConnName: UILabel!
    @IBOutlet weak var lblStationAdd: UILabel!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var couponView: UIView!
    @IBOutlet weak var waletView: UIView!
    @IBOutlet weak var lblTotalTax: UILabel!
    @IBOutlet weak var lblDiscountValue: UILabel!
    @IBOutlet weak var lblOrderAmt: UILabel!
    @IBOutlet weak var lblUnit: UILabel!
    @IBOutlet weak var txtCoupon: UITextField!
    @IBOutlet weak var lblWaletAmt: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lbUnit: UILabel!
    
    var orderAmount = 0
    var orderUnits = 0
    var timeInMinutes = "0"
    var waletAmount = Float()
    var amountFlag = false
    var unitsFlag = false
    var timeFlag = false
    var amount = 0
    var chargerBoxId:String = ""
    var connName = ""
    var stationName = ""
    var stationAddress = ""
    var connectorType = ""
    var parkingPrice = "0.0"
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnNext.layer.cornerRadius = 12
        self.waletView.layer.cornerRadius = 12
        self.couponView.layer.cornerRadius = 12
        self.detailsView.layer.cornerRadius = 16
        self.waletView.layer.borderWidth = 1
        self.waletView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.couponView.layer.borderWidth = 1
        self.couponView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.detailsView.layer.borderWidth = 1
        self.detailsView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.lblNote.text = "Note: Parking chargers of ₹\(parkingPrice).0/hr will be charged after the transaction."
        if connectorType == "DC" {
            imgConnectorType.image = UIImage(named: "dc")
        }else {
            imgConnectorType.image = UIImage(named: "ac")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getWaletAmtApi()
        if amountFlag == true{
            callamountUnitApi()
        }else if unitsFlag == true{
            callpowerUnitApi()
        }else if timeFlag == true {
            // call time API
            callUnitTimeAPI()
        }
        self.lblConnName.text =  "Connector ID: " + connName
        self.lblStationName.text = stationName
        self.lblStationAdd.text = stationAddress
        
    }
    
    @IBAction func back(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingStationVC") as! ChargingStationVC
//        self.present(nextViewController, animated:true, completion:nil)
        self.dismiss(animated: true)
    }
    
    @IBAction func next(_ sender: Any) {
        print("Order Amounnt\( self.amount)")
        print("Wallet Amounnt\(waletAmount)")
        let unit = lblUnit.text
        let amount = lblOrderAmt.text
        UserAppStorage.unit = unit
        UserAppStorage.amount = amount
     //   if waletAmount < Float(orderAmount){
        if waletAmount > Float(orderAmount){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StartChargingVC") as! StartChargingVC
            
        nextViewController.unit = Double(Float(orderAmount))
        nextViewController.connName = connName
        nextViewController.chargerBoxId = chargerBoxId
            nextViewController.timeBasedCharging = timeFlag
            nextViewController.chargingTimeInMinutes = Int(timeInMinutes) ?? 0
            self.present(nextViewController, animated:true, completion:nil)
        }else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddMmoneyVC") as! AddMmoneyVC
            
//        nextViewController.amount = amount
//        nextViewController.connName = connName
//        nextViewController.chargerBoxId = chargerBoxId
            self.present(nextViewController, animated:true, completion:nil)
        }
  
      
         
    }
    @IBAction func applyCoupon(_ sender: Any) {
        callApplyCouponApi()
    }
    @IBAction func viewCoupon(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AvailableCouponVC") as! AvailableCouponVC
        self.present(nextViewController, animated:true, completion:nil)
    }


}
extension ChargingUnitVC{
    func callamountUnitApi(){
        let amountUnit = EndPoints.shared.baseUrlDev + EndPoints.shared.amountUnit
        let userPk = UserAppStorage.userPk
        let chrBoxId =  UserAppStorage.chrgBoxId
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "amount": orderAmount,
            "connectorId":connName,
            "chargeboxId": chargerBoxId,
            "corporateUser": true,
            "corporateCode": ""
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(amountUnit, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
//                let energyInWatts = jsonData["energyInWatts"].floatValue
//                let amount = jsonData["amount"].doubleValue
//                let tax = (self.orderAmount * 18)/100
//
//                self.lbUnit.text = "Unit"
////                self.amount = amount
//                self.lblUnit.text = String(format: "%.2f", energyInWatts) + " kW"
//                self.lblOrderAmt.text = "₹" + String(format: "%.2f", amount)
//                self.lblTotalTax.text =  "₹" + String(format: "%.2f", amount)
//                self.lblDiscountValue.text =  "₹" + "0.00"
                
                let energyInWatts = jsonData["energyInWatts"].floatValue
                let amount = jsonData["amount"].intValue
                let tax = (self.orderAmount * 18)/100

                self.amount = amount
                self.lblUnit.text = String(energyInWatts)
                self.lblOrderAmt.text =    String(amount)
                self.lblTotalTax.text =  "Rs. " + String(amount)
                self.lblDiscountValue.text =  "Rs. " + "00"
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    func callpowerUnitApi(){
        let amountUnit = EndPoints.shared.baseUrlDev + EndPoints.shared.wattAmount
        let userPk = UserAppStorage.userPk
        let chrBoxId =  UserAppStorage.chrgBoxId
        UserAppStorage.requestedUnit = orderAmount
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "energyInWatts": self.orderAmount,
            "chargeboxId": chargerBoxId,
            "corporateUser": false,
            "corporateCode": "",
            "connectorId":connName
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(amountUnit, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                
                let energyInWatts = jsonData["energyInWatts"].floatValue
                let amount = jsonData["amount"].intValue
                let tax = (self.orderAmount * 18)/100

                self.amount = amount
                self.lblUnit.text = String(energyInWatts)
                self.lblOrderAmt.text =    String(amount)
                self.lblTotalTax.text =  "Rs. " + String(amount)
                self.lblDiscountValue.text =  "Rs. " + "00"
                
//                let energyInWatts = jsonData["energyInWatts"].doubleValue
//                let amount = jsonData["amount"].doubleValue
//                let tax = amount * 18/100
//
//                self.lbUnit.text = "Unit"
////                self.amount = amount
//                self.lblUnit.text = String(energyInWatts) + " kW"
//                self.lblOrderAmt.text = "₹" + String(format: "%.2f", amount)
//                self.lblTotalTax.text =  "₹" + String(format: "%.2f", amount)
//                self.lblDiscountValue.text =  "₹" + "0.00"
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    // Time base API
    func callUnitTimeAPI(){
        let amountUnit = EndPoints.shared.baseUrlDev + EndPoints.shared.timeAmount
        let userPk = UserAppStorage.userPk
        let chrBoxId =  UserAppStorage.chrgBoxId
        UserAppStorage.requestedUnit = orderAmount
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "timeInMinutes": timeInMinutes,
            "chargeboxId": chargerBoxId,
            "corporateUser": false,
            "corporateCode": "",
            "connectorId":connName
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(amountUnit, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                
                let energyInWatts = jsonData["energyInWatts"].floatValue
                let amount = jsonData["amount"].intValue
                let tax = amount * 18/100

                self.amount = amount
                self.lblUnit.text = String(energyInWatts)
                self.lblOrderAmt.text =    String(amount)
                self.lblTotalTax.text =  "Rs. " + String(amount)
                self.lblDiscountValue.text =  "Rs. " + "00"
                
//                let energyInWatts = jsonData["energyInWatts"].floatValue
//                let amount = jsonData["amount"].doubleValue
//                let time = jsonData["timeInMinutes"].intValue
//                let tax = amount * 18/100
//
//                self.lbUnit.text = "Time"
//                self.amount = amount
//                self.lblUnit.text = String(time) + " Mins"
//                self.lblOrderAmt.text = "₹" + String(format: "%.2f", amount)
//                self.lblTotalTax.text =  "₹" + String(format: "%.2f", amount)
//                self.lblDiscountValue.text =  "₹" + "0.00"
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    func callApplyCouponApi(){
        let amountUnit = EndPoints.shared.baseUrlDev + EndPoints.shared.discountCoupon
        let userPk = UserAppStorage.userPk
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "userPk": userPk,
            "amount":"100",
            "couponCode": txtCoupon.text
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(amountUnit, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                let status = jsonData["status"].stringValue
                let message = jsonData["message"].stringValue
                self.showToast(title: "", message: message)
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
        func getWaletAmtApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.getWaletAmt
            let userPk = UserAppStorage.userPk
        LoadingOverlay.shared.showOverlay(view: view)
            let parameters = [
                    "userPk": userPk
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
                           
                            let status = jsonData["status"].bool
                            let amount = jsonData["amount"].floatValue
                            let userWalletAccountId = jsonData["userWalletAccountId"].double
                            self.lblWaletAmt.text = "₹" + String(amount ?? 0)
                            self.waletAmount = amount
                      
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
