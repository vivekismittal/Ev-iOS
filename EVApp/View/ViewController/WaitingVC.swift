//
//  WaitingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 29/06/23.
//

import UIKit
import AudioToolbox

class WaitingVC: UIViewController {
    
    @IBOutlet weak var proView: UIView!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var instView: UIView!
    @IBOutlet weak var lblRemSecond: UILabel!
    
    var secondsRemaining = 120
    
    private var progressViewCircle = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), lineWidth: 15, rounded: false)
    private var timer: Timer?
    
    var moveChargedVC = true
//    var timerDispatchSourceTimer : DispatchSourceTimer?
    private var chargingViewModel: ChargingViewModel!
    private var chargingData: ChargingVCModel!

    
    static func instantiateFromStoryboard(with chargingViewModel: ChargingViewModel,chargingData: ChargingVCModel) -> Self {
        let waitingVC = ViewControllerFactory<Self>.viewController(for: .ChargingWaitingScreen)
        waitingVC.chargingViewModel = chargingViewModel
        waitingVC.chargingData = chargingData
        return waitingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.vibrate()
        self.proView.isHidden = true
        self.instView.layer.cornerRadius  = 15
        self.btnStart.layer.cornerRadius  = 8
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.progressView()
        timer =  Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            self.progressView()
        }
    }
    
    @IBAction func start(_ sender: Any) {
        self.secondsRemaining = 120
        self.proView.isHidden = true
        self.progressView()
        timer =  Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            self.progressView()
            print("running")
        }
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounter), userInfo: nil, repeats: true)
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
        self.getChargingMeterUpdate()
        progressViewCircle = CircularProgressView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), lineWidth: 15, rounded: false)
        progressViewCircle.progressColor = #colorLiteral(red: 0.4919497967, green: 0.7860459685, blue: 0, alpha: 1)
        progressViewCircle.trackColor = .lightGray
        progressViewCircle.progress = 1.0
        progressViewCircle.center = self.view.center
      // progressView.frame = self.proView.bounds
        
        self.view.addSubview(progressViewCircle)
       
    }

    func getChargingMeterUpdate(){
        guard chargingData.userTransactionId != nil else { return }
        chargingViewModel.getMeterValuesUpdate(transactionId: chargingData.userTransactionId!, connectorName: chargingData.connectorName, chargerBoxId: chargingData.chargerBoxId){[weak self] res in
            guard let self else { return }
            switch res{
            case .success(let chargingMeterValues):
                if chargingMeterValues.error != "Meter Value Details Not Found",
                   chargingMeterValues.meterValues != nil,
                   !chargingMeterValues.meterValues!.isEmpty {
                    if !self.moveChargedVC{
                        return
                    }
                    self.timer?.invalidate()
                    self.timer = nil
                    MainAsyncThread {
                        
                        self.moveChargedVC = false
                        let nextViewController = ChargingVC.instantiateFromStoryboard(
                            with: self.chargingViewModel,
                            self.chargingData
                        )
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}


//extension WaitingVC{
//    func callTrxStartApi(){
//        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.trxStart
//        let userPk = UserAppStorage.userPk
//        var chrBoxId =  UserAppStorage.chrgBoxId
//        LoadingOverlay.shared.showOverlay(view: view)
//            let parameters = [
//                "connectorId":connName,
//                "idTag":"tag001",
//                "chargeBoxIdentity":chargerBoxId,
//                "amount":orderChargingAmount,
//                "userPk":userPk,
//                "paymentTransactionId": 0
//                    ] as? [String:AnyObject]
//        print(parameters)
//        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
//                    response in
//                LoadingOverlay.shared.hideOverlayView()
//
//                        switch (response.result) {
//
//                        case .success(let value):
//                            print(response)
//                            
//                    let statusCode = response.response?.statusCode
//                            print(statusCode!)
//                            
//                    let jsonData = JSON(value)
//                            print(jsonData)
//                            
//                            let userTransactionId = jsonData["userTransactionId"].string
//                            if let userTransactionId{
//                                self.userTransactionId = userTransactionId
//                            }
//                            
//                           // let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
////                             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingVC") as! ChargingVC
////                            nextViewController.orderAmount = Int(self.unit)
////                            nextViewController.connName = self.connName
////
////                            nextViewController.chargerBoxId = self.chargerBoxId
////                            nextViewController.userTransactionId =  self.transaId
////                            self.present(nextViewController, animated:true, completion:nil)
//    //                        let status = jsonData["status"].bool
//    //                        let amount = jsonData["amount"].floatValue
//    //                        let userWalletAccountId = jsonData["userWalletAccountId"].double
//    //                        self.lblWaletAmt.text = "Rs.: " + String(amount ?? 0)
//    //                        self.waletAmount = amount
//                      
//                            break
//                        case .failure:
//                            print(Error.self)
//                           
//                        }
//                    }
//    }
    
   
//    
//     func callMeterValuesApi(){
//        let metervalues  = EndPoints.shared.baseUrlDev + EndPoints.shared.trxMeterValues
////        let chrBoxId =  UserAppStorage.chrgBoxId
//     //   LoadingOverlay.shared.showOverlay(view: view)
//        let parameters = [
//            "userTransactionId": String(userTransactionId),
//            "chargeBoxIdentity": chargerBoxId,
//            "connectorId":  self.connName,
//            "idTag":"user001"
//        ] as? [String:AnyObject]
//        //{"chargeBoxIdentity":"1212","connectorId":1,"idTag":"user001","userTransactionId":"384"}
////        print(parameters)
////        print(orderAmount)
//        AF.request(metervalues, method:.post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
//            response in
//          //  LoadingOverlay.shared.hideOverlayView()
//            
//            switch (response.result) {
//                
//            case .success(let value):
//                print(response)
//                
//                let statusCode = response.response?.statusCode
//                print(statusCode!)
//                
//                let jsonData = JSON(value)
//                print(jsonData)
//                
//                let status = jsonData["status"].string
//                if status == "true"{
//                   // error = "Meter Value Details Not Found";
////                    let startTime = jsonData["startTime"].string
//                    let error = jsonData["error"].string
////                    let stopTime = jsonData["stopTime"].string
////                    let amountDeducted = jsonData["amountDeducted"].int
////                    let chargeBoxId = jsonData["chargeBoxId"].bool
////                    let amount = jsonData["amount"].int
////                    let stopValue = jsonData["stopValue"].string
////                    let totalTime = jsonData["totalTime"].string
////                    let meter = jsonData.dictionaryValue["meterValues"]?.arrayValue
////                    let valueUnit = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["unit"].stringValue}
////                    let value = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["value"].intValue}
//                    let timeBasedCharging = jsonData.dictionaryValue["timerBasedCharging"]!.boolValue
//                  //  self.lblStartTime.text = startTime
//                  //  self.lblStartTime.text = startTime
//                    if error != "Meter Value Details Not Found"{
//                        if !self.moveChargedVC{
//                            return
//                        }
//                        self.timer?.invalidate()
//                        self.timer = nil
//                        let nextViewController = ChargingVC.instantiateFromStoryboard(orderChargingUnitInWatt: self.orderChargingUnitInWatt, orderChargingAmount: self.orderChargingAmount)
//                        nextViewController.connName = self.connName
//                        self.moveChargedVC = false
//                        nextViewController.chargerBoxId = self.chargerBoxId
//                        nextViewController.userTransactionId =  self.userTransactionId
//                        nextViewController.timeBasedCharging = timeBasedCharging
//                        self.present(nextViewController, animated:true, completion:nil)
//                        
//                        
//                    }
////                    for wh in valueUnit{
////                        if wh == "Wh"{
////                            self.unitCons.append(contentsOf: value)
////                        }
////                        print(self.unitCons)
////                    }
////                    let cUnit = (self.unitCons.last ?? 0) - (self.unitCons.first ?? 0)
////                    let conUnit = value.last
////                    let unit = cUnit/1000
//                   // self.conUnit = String(unit)
//                   // print(conUnit)
////                    self.lblUnitConsumed.text = String(unit) + " Unit"
////                    if Float(unit) >= Float(orderUnit ?? "0") ?? 0.0 {
////                        DispatchQueue.main.async {
////                            self.callTrxStopApi()
////                            print("Stop Charging")
////                            //self.timer.invalidate()
////                        }
////                    }else{
////                        print("Charging")
////                    }
//                }
//                break
//            case .failure:
//                print(Error.self)
//            }
//        }
//    }
//}
extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}


