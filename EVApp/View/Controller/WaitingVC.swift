//
//  WaitingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 29/06/23.
//

import UIKit
import AudioToolbox
import Alamofire
import SwiftyJSON

class WaitingVC: UIViewController {
    @IBOutlet weak var proView: UIView!
  //  var timer = Timer()
    @IBOutlet weak var btnStart: UIButton!
     var timer: Timer?
    @IBOutlet weak var instView: UIView!
    var timerDispatchSourceTimer : DispatchSourceTimer?
    @IBOutlet weak var lblRemSecond: UILabel!
    var secondsRemaining = 120
    var progressViewCircle = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), lineWidth: 15, rounded: false)
    var unit  = 0.0
    var connName = ""
    var chargerBoxId:String = ""
    var unitCons = [Int]()
    var userTransactionId = 0
    var conUnit = String()
    var orderAmount = 0
    var transaId = Int()
    var moveChargedVC = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.transaId = userTransactionId
        UIDevice.vibrate()
        self.proView.isHidden = true
        self.instView.layer.cornerRadius  = 15
        self.btnStart.layer.cornerRadius  = 8
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        //timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.callMeterValuesApi), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { (timer) in
            self.callMeterValuesApi()
            print("running")
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.progressView()
        self.callMeterValuesApi()
        timer =  Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            self.progressView()
            print("running")
        }
    }
    @IBAction func start(_ sender: Any) {
        self.secondsRemaining = 120
        self.proView.isHidden = true
     //   self.progressViewCircle.isHidden = false
        self.progressView()
        timer =  Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            self.progressView()
            print("running")
        }
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
        callTrxStartApi()
    }
    @objc func updateCounter(){
        if secondsRemaining > 0 {
            print("Seconds remaining: \(secondsRemaining)")
            self.lblRemSecond.text = ("Seconds remaining: \(secondsRemaining)")
            secondsRemaining -= 1
        }
        if secondsRemaining == 1{
            self.proView.isHidden = false
            self.progressViewCircle.isHidden = true
            timer?.invalidate()
            timer =  nil
            Timer.cancelPreviousPerformRequests(withTarget: updateCounter())
            self.secondsRemaining = 120
           
        }

    }
    func progressView(){
      
        progressViewCircle = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), lineWidth: 15, rounded: false)
        progressViewCircle.progressColor = #colorLiteral(red: 0.4919497967, green: 0.7860459685, blue: 0, alpha: 1)
        progressViewCircle.trackColor = .lightGray
        progressViewCircle.progress = 1.0
        progressViewCircle.center = self.view.center
      // progressView.frame = self.proView.bounds
        
        self.view.addSubview(progressViewCircle)
       
    }

}
extension WaitingVC{
    func callTrxStartApi(){
        let verifyOtp  = EndPoints().baseUrlDev + EndPoints().trxStart
        let userPk = UserDefaults.standard.integer(forKey: "userPk")
       var chrBoxId =  UserDefaults.standard.string(forKey: "chrgBoxId")
        let orderAmt =  UserDefaults.standard.string(forKey: "AMOUNT")
        LoadingOverlay.shared.showOverlay(view: view)
            let parameters = [
                "connectorId":connName,
                "idTag":"tag001",
                "chargeBoxIdentity":chargerBoxId,
                "amount":orderAmt,
                "userPk":userPk,
                "paymentTransactionId": 0
                    ] as? [String:AnyObject]
        print(parameters)
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
                            
                            let userTransactionId = jsonData["userTransactionId"].intValue
                            self.transaId  = userTransactionId
                            
                           // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingVC") as! ChargingVC
//                            nextViewController.orderAmount = Int(self.unit)
//                            nextViewController.connName = self.connName
//
//                            nextViewController.chargerBoxId = self.chargerBoxId
//                            nextViewController.userTransactionId =  self.transaId
//                            self.present(nextViewController, animated:true, completion:nil)
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
    @objc func callMeterValuesApi(){
        let metervalues  = EndPoints().baseUrlDev + EndPoints().trxMeterValues
        //let userPk = UserDefaults.standard.integer(forKey: "userPk")
        let chrBoxId =  UserDefaults.standard.string(forKey: "chrgBoxId")
     //   LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "userTransactionId":String(userTransactionId),
            "chargeBoxIdentity":chargerBoxId,
            "connectorId":  self.connName,
            "idTag":"user001"
        ] as? [String:AnyObject]
        //{"chargeBoxIdentity":"1212","connectorId":1,"idTag":"user001","userTransactionId":"384"}
        print(parameters)
        print(orderAmount)
        AF.request(metervalues, method:.post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
          //  LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                let status = jsonData["status"].string
                if status == "true"{
                   // error = "Meter Value Details Not Found";
                    let startTime = jsonData["startTime"].string
                    let error = jsonData["error"].string
                    let stopTime = jsonData["stopTime"].string
                    let amountDeducted = jsonData["amountDeducted"].int
                    let chargeBoxId = jsonData["chargeBoxId"].bool
                    let amount = jsonData["amount"].int
                    let stopValue = jsonData["stopValue"].string
                    let totalTime = jsonData["totalTime"].string
                    let meter = jsonData.dictionaryValue["meterValues"]?.arrayValue
                    let valueUnit = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["unit"].stringValue}
                    let value = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["value"].intValue}
                    let timeBasedCharging = jsonData.dictionaryValue["timerBasedCharging"]!.boolValue
                  //  self.lblStartTime.text = startTime
                  //  self.lblStartTime.text = startTime
                    let orderUnit = UserDefaults.standard.string(forKey: "UNIT")
                    if error != "Meter Value Details Not Found"{
                        if !self.moveChargedVC{
                            return
                        }
                        self.timer?.invalidate()
                        self.timer = nil
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingVC") as! ChargingVC
                        nextViewController.orderAmount = Int(self.unit)
                        nextViewController.connName = self.connName
                        self.moveChargedVC = false
                        nextViewController.chargerBoxId = self.chargerBoxId
                        nextViewController.userTransactionId =  self.transaId
                        nextViewController.timeBasedCharging = timeBasedCharging
                        self.present(nextViewController, animated:true, completion:nil)
                        
                        
                    }
//                    for wh in valueUnit{
//                        if wh == "Wh"{
//                            self.unitCons.append(contentsOf: value)
//                        }
//                        print(self.unitCons)
//                    }
//                    let cUnit = (self.unitCons.last ?? 0) - (self.unitCons.first ?? 0)
//                    let conUnit = value.last
//                    let unit = cUnit/1000
                   // self.conUnit = String(unit)
                   // print(conUnit)
//                    self.lblUnitConsumed.text = String(unit) + " Unit"
//                    if Float(unit) >= Float(orderUnit ?? "0") ?? 0.0 {
//                        DispatchQueue.main.async {
//                            self.callTrxStopApi()
//                            print("Stop Charging")
//                            //self.timer.invalidate()
//                        }
//                    }else{
//                        print("Charging")
//                    }
                }
                break
            case .failure:
                print(Error.self)
            }
        }
    }
}
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
