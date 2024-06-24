//
//  ChargingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 30/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChargingVC: UIViewController {
    @IBOutlet weak var unnitPurchased: UILabel!
    
    @IBOutlet weak var lblAmountPaid: UILabel!
    @IBOutlet weak var lblUnitPurchased: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblTotalTime: UILabel!
    @IBOutlet weak var lblTimeConsumed: UILabel! // amount paid
    @IBOutlet weak var lblUnitConsumed: UILabel! // unit consumed
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    var unitCons = [Float]()
    var userTransactionId = 0
    var secondsRemaining = 120
    var connName = ""
    var chargerBoxId:String = ""
//    var orderAmount = Float()
    weak var timer: Timer?
    var conUnit = String()
    var timeBasedCharging = false
    private var orderChargingUnitInWatt: Float!
    private var orderChargingAmount: Float!
    
    static func instantiateUsingStoryboard(orderChargingUnitInWatt: Float,orderChargingAmount: Float) -> Self {
        let chargingVC = ViewControllerFactory<Self>.viewController(for: .OnGoingChargingScreen)
        chargingVC.orderChargingAmount  = orderChargingAmount
        chargingVC.orderChargingUnitInWatt = orderChargingUnitInWatt
        return chargingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStop.layer.cornerRadius = 12
        self.startView.layer.cornerRadius = 12
        self.amountView.layer.cornerRadius = 12
        addLocalNotification()
        updateTimeBasedUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let orderUnit = UserAppStorage.unit
//        let orderAmt =  UserAppStorage.amount
//        let requestedUnit = UserAppStorage.requestedUnit
        self.lblUnitPurchased.text = "\(orderChargingUnitInWatt!) kWh"
        self.lblAmountPaid.text =  orderChargingAmount.rupeeString()
        callMeterValuesApi()
       // executeRepeatedly()
        timer =  Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
            self.callMeterValuesApi()
        }
      //  self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        
    }
    
    func updateTimeBasedUI(){
        if timeBasedCharging {
            lblTotalTime.text = "Total Time(mins)"
            lblTimeConsumed.text = "Time Remaining(mins)"
            startView.layer.cornerRadius = 5
            startView.backgroundColor = UIColor.lightGray
            amountView.layer.cornerRadius = 5
            amountView.backgroundColor = UIColor.lightGray
        }else {
            lblTotalTime.text = "Amount Paid"
            lblTimeConsumed.text = "Unit Purchased"
        }
    }
    func addLocalNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Yahhvi - EV Charging"
        content.subtitle = "Your charging is in progress."
        content.sound = UNNotificationSound.default

        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: "chargingalert", content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
    }
    @IBAction func back(_ sender: Any) {
       
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = MenuNavigation.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func stopChargingPressed(_ sender: Any) {
        callTrxStopApi()
    }
    
//    func executeRepeatedly(){
//        self.callMeterValuesApi()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { [weak self] in
//            self?.executeRepeatedly()
//        }
//    }
//    @objc func updateCounter(){
//        if secondsRemaining > 0 {
//            print("\(secondsRemaining) seconds.")
//            secondsRemaining -= 1
//        }
//    }
 
    func callTrxStopApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.trxStop
        let userPk = UserAppStorage.userPk
        let chrBoxId =  UserAppStorage.chrgBoxId
      //  LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "userTransactionId":String(userTransactionId),
            "chargeBoxIdentity":chargerBoxId
        ] as? [String:AnyObject]
        //    let parameters = [
        //        "userTransactionId":471,
        //        "chargeBoxIdentity":20210224013
        //            ] as? [String:AnyObject]
        print(parameters)
        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { [self]
            response in
          //  LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["chargingalert"])
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextVC = storyBoard.instantiateViewController(withIdentifier: "TransactionDetailsVC") as!
                TransactionDetailsVC
                //                        nectVC.INR = lblAmountPaid.text ?? "NA"
                //                        nectVC.rs = lblAmountPaid.text ?? "NA"
                //                        nectVC.time = lblStartTime.text ?? "NA"
                //                        nectVC.power = lblUnitConsumed.text ?? "NA"
                nextVC.consUnit = conUnit
                nextVC.userTransactionId = String(userTransactionId)
                //                        nectVC.station = String(userTransactionId)
                //                        nectVC.vehModel = "NA"
                
                self.present(nextVC, animated:true, completion:nil)
                
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    
    func callMeterValuesApi(){
        let metervalues  = EndPoints.shared.baseUrlDev + EndPoints.shared.trxMeterValues
        let chrBoxId =  UserAppStorage.chrgBoxId
     //   LoadingOverlay.shared.showOverlay(view: view)
        //self.showSpinner(onView: view)
       
        let parameters = [
            "userTransactionId":String(userTransactionId),
            "chargeBoxIdentity":chargerBoxId,
            "connectorId":  self.connName,
            "idTag":"user001"
        ] as? [String:AnyObject]
        //{"chargeBoxIdentity":"1212","connectorId":1,"idTag":"user001","userTransactionId":"384"}
        print(parameters)
//        print(orderAmount)
        AF.request(metervalues, method:.post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
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
                if status == "true"{
                    
                    let startTime = jsonData["startTime"].string
                    let stopTime = jsonData["stopTime"].string
                    let amountDeducted = jsonData["amountDeducted"].int
                    let chargeBoxId = jsonData["chargeBoxId"].bool
                    let amount = jsonData["amount"].int
                    let stopValue = jsonData["stopValue"].string
                    let totalTime = jsonData["totalTime"].string
                    let valueUnit = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["unit"].stringValue}
                    let value = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["value"].floatValue}
                    let timeBasedCharging = jsonData.dictionaryValue["timerBasedCharging"]!.boolValue
                    let totalTimeRemainingInMinutes = jsonData.dictionaryValue["totalTimeRemainingInMinutes"]!.intValue
                    let totalChargingTimeInMinutes = jsonData.dictionaryValue["chargingTimeInMinutes"]!.intValue
                    self.lblStartTime.text = startTime
                    self.lblStartTime.text = startTime
//                    let orderUnit = UserAppStorage.unit
                    if valueUnit.count == 0 {
                       // self.timer?.invalidate()
                    }
//                    for wh in valueUnit{
//                        if wh == "Wh"{
//                            
//                            self.unitCons.append(contentsOf: value)
//                        }
//                        print(self.unitCons)
//                    }
                    if valueUnit.count > 0 {
                        for index in 0...(valueUnit.count - 1){
                            if valueUnit[index] == "Wh"{
                                
                                self.unitCons.append(value[index])
                            }
                            print(self.unitCons)
                        }
                    }
                        let cUnit = (self.unitCons.last ?? 0) - (self.unitCons.first ?? 0)
                        let conUnit = value.last
                        let unit = cUnit / 1000
                        self.conUnit = String(unit)
                        // print(conUnit)
                        self.lblUnitConsumed.text = String(unit) + " Unit"
                    
                    if timeBasedCharging {
                        self.lblUnitPurchased.text = "\(totalTimeRemainingInMinutes)"
                        self.lblAmountPaid.text = "\(totalChargingTimeInMinutes)"
                        if  totalTimeRemainingInMinutes == 0 {
                            DispatchQueue.main.async {
                                self.callTrxStopApi()
                                print("Stop Charging")
                                //self.timer.invalidate()
                            }
                        }
                    } else {
                        if unit >= self.orderChargingUnitInWatt {
                            DispatchQueue.main.async {
                                self.callTrxStopApi()
                                print("Stop Charging")
                                //self.timer.invalidate()
                            }
                        }else{
                            print("Charging")
                        }
                    }
                }
                break
            case .failure:
                print(Error.self)
            }
        }
    }
    
}
