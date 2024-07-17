//
//  ChargingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 30/05/23.
//  Corrected by Vivek Mittal (VM)

import UIKit
import Lottie

class ChargingVC: UIViewController {
    
    @IBOutlet weak var progressRingView: UIView!
    @IBOutlet weak var carChargingLottieAnimationView: LottieAnimationView!
    @IBOutlet weak var unnitPurchased: UILabel!
    @IBOutlet weak var amountPaidValue: UILabel!
    @IBOutlet weak var chargingQuantityValue: UILabel!
    @IBOutlet weak var amountView: UIView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var amountPaidTitle: UILabel!
    @IBOutlet weak var chargingQuantityTitle: UILabel!
    @IBOutlet weak var lblUnitConsumed: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    
    private weak var timer: Timer?
    private var progressRingData: ProgressRingObservableData!
    private var consumedUnit = Float()
    private let localNotificationService: LocalNotificationProtocol = LocalNotificationService()
    
    private var chargingVCData: ChargingVCModel!
    private var chargingViewModel: ChargingViewModel!
    
    static func instantiateFromStoryboard(with viewModel: ChargingViewModel = ChargingViewModel(),_ chargingVCData: ChargingVCModel) -> Self {
        let chargingVC = ViewControllerFactory<Self>.viewController(for: .OnGoingChargingScreen)
        chargingVC.chargingViewModel = viewModel
        chargingVC.chargingVCData = chargingVCData
        return chargingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStop.layer.cornerRadius = 12
        self.startView.layer.cornerRadius = 12
        self.amountView.layer.cornerRadius = 12
        updateTimeBasedUI()
        addProgressRingView()
        amountPaidValue.text = chargingVCData.orderChargingAmount.rupeeString(withPrecision: 1)
        getUpdatedChargindMeterValues()
        setupCarChargingAnimationView()

        // executeRepeatedly()
        timer =  Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) {[weak self] (timer) in
            self?.getUpdatedChargindMeterValues()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        addLocalNotification()
    }
    
    private func setupCarChargingAnimationView(){

        carChargingLottieAnimationView.contentMode = .scaleAspectFit
        
        carChargingLottieAnimationView.loopMode = .loop
        
        carChargingLottieAnimationView.animationSpeed = 0.5
        
        carChargingLottieAnimationView.play()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        carChargingLottieAnimationView.stop()
    }
    
    func updateTimeBasedUI(){
        if chargingVCData.timeBasedCharging {
            chargingQuantityTitle.text = "Charging Time(mins)"
            chargingQuantityValue.text = String(chargingVCData.chargingTimeInMinutes)
            
            startView.layer.cornerRadius = 5
            startView.backgroundColor = UIColor.lightGray
            amountView.layer.cornerRadius = 5
            amountView.backgroundColor = UIColor.lightGray
        } else {
            chargingQuantityTitle.text = "Unit Purchased"
            self.chargingQuantityValue.text = chargingVCData.orderChargingUnitInWatt.precisedString(upTo: 2) + " kWh"
        }
    }
    
    func addLocalNotification(){
        localNotificationService.dispatchNotification(title: "Yahhvi - EV Charging", body: "Your charging is in progress.", identifier: .chargingOnGoing,userInfo: chargingVCData)
    }
    
    @IBAction func back(_ sender: Any) {
        timer?.invalidate()
        gotoHome()
    }
    
    @IBAction func stopChargingPressed(_ sender: Any) {
        stopCharging()
    }
    
    private func addProgressRingView(){
        let image: String
        let progressColor = #colorLiteral(red: 0.4919497967, green: 0.7860459685, blue: 0, alpha: 1)
        
        if chargingVCData.timeBasedCharging{
            progressRingData = .init(
                percentage: 1,
                label: formatTimeInMinutes(timeInMinutes: Float(chargingVCData.chargingTimeInMinutes))
            )
            image = "time"
        } else{
            progressRingData = .init(percentage: 0, label: "0%")
            image = "currentShock"
        }
        
        let ringUIView = ProgressRingView(trackColor: .gray, progressColor: progressColor, iconImage: image, progressRingData: progressRingData).getUIKitView()
        ringUIView.backgroundColor = .clear
        ringUIView.translatesAutoresizingMaskIntoConstraints = false
        
        progressRingView.addSubview(ringUIView)
        
        NSLayoutConstraint.activate([
            ringUIView.topAnchor.constraint(equalTo: progressRingView.topAnchor),
            ringUIView.leftAnchor.constraint(equalTo: progressRingView.leftAnchor),
            ringUIView.rightAnchor.constraint(equalTo: progressRingView.rightAnchor),
            ringUIView.bottomAnchor.constraint(equalTo: progressRingView.bottomAnchor),
        ])
    }
    
    
    
    private func stopCharging(){
        guard chargingVCData.userTransactionId != nil else { return }
        chargingViewModel.stopCharging(userTransactionId: chargingVCData.userTransactionId!, chargerBoxId: chargingVCData.chargerBoxId){[weak self] res in
            switch res{
            case .success(_):
                MainAsyncThread {
                    self?.localNotificationService.removeNotification(.chargingOnGoing)
                    self?.redirectToInvoicePage()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func redirectToInvoicePage(){
        timer?.invalidate()
        guard chargingVCData.userTransactionId != nil else { return }
        let nextVC = TransactionDetailsVC.instantiateFromStoryboard()
        nextVC.consUnit = self.consumedUnit
        nextVC.userTransactionId = String(chargingVCData.userTransactionId!)
        self.present(nextVC, animated:true, completion:nil)
    }
    
    private func getUpdatedChargindMeterValues(){
        guard chargingVCData.userTransactionId != nil else { return }

        chargingViewModel.getMeterValuesUpdate(transactionId: chargingVCData.userTransactionId!, connectorName: chargingVCData.connectorName, chargerBoxId: chargingVCData.chargerBoxId){[weak self] res in
            guard let self else { return }
            switch res{
            case .success(let chargingMeterValues):
                
                if chargingMeterValues.status == "true"{
                    
                    MainAsyncThread {
                        self.lblStartTime.text = chargingMeterValues.startTime
                        let firstValue = chargingMeterValues.meterValues?.first{$0.unit == .wh}?.value ?? 0
                        let lastValue = chargingMeterValues.meterValues?.last{$0.unit == .wh}?.value ?? 0
                        
                        self.consumedUnit = (lastValue - firstValue) / 1000
                        
                        self.lblUnitConsumed.text =  self.consumedUnit.precisedString(upTo: 2) + " Unit"
                        
                        if chargingMeterValues.timerBasedCharging == true {
                            self.progressRingData.updateData(
                                percentage: (chargingMeterValues.totalTimeRemainingInMinutes ?? 00) / Float(self.chargingVCData.chargingTimeInMinutes),
                                label: self.formatTimeInMinutes(
                                    timeInMinutes: chargingMeterValues.totalTimeRemainingInMinutes ?? 0)
                            )
                            
                            if  chargingMeterValues.totalTimeRemainingInMinutes == 0 {
                                self.redirectToInvoicePage()
                            }
                            
                        } else {
                            self.progressRingData.updateData(
                                percentage: self.consumedUnit / self.chargingVCData.orderChargingUnitInWatt,
                                label: "\(((self.consumedUnit / self.chargingVCData.orderChargingUnitInWatt) * 100).precisedString(upTo: 0))%"
                            )
                            
                            if self.consumedUnit >= self.chargingVCData.orderChargingUnitInWatt {
                                self.redirectToInvoicePage()
                            } else {
                                print("Charging")
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func formatTimeInMinutes(timeInMinutes: Float) -> String {
        let totalSeconds = timeInMinutes * 60
        let hours = Int(totalSeconds / 3600)
        let minutes = Int((totalSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
        return String(format: "%02d:%02d", hours, minutes)
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
    
    //    func callMeterValuesApi(){
    //        let metervalues  = EndPoints.shared.baseUrlDev + EndPoints.shared.trxMeterValues
    //        let chrBoxId =  UserAppStorage.chrgBoxId
    //     //   LoadingOverlay.shared.showOverlay(view: view)
    //        //self.showSpinner(onView: view)
    //
    //        let parameters = [
    //            "userTransactionId":String(userTransactionId),
    //            "chargeBoxIdentity":chargerBoxId,
    //            "connectorId":  self.connName,
    //            "idTag":"user001"
    //        ] as? [String:AnyObject]
    //        //{"chargeBoxIdentity":"1212","connectorId":1,"idTag":"user001","userTransactionId":"384"}
    //        print(parameters)
    ////        print(orderAmount)
    //        AF.request(metervalues, method:.post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
    //            response in
    //          //  LoadingOverlay.shared.hideOverlayView()
    //
    //            self.removeSpinner()
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
    //
    //                    let startTime = jsonData["startTime"].string
    ////                    let stopTime = jsonData["stopTime"].string
    ////                    let amountDeducted = jsonData["amountDeducted"].int
    ////                    let chargeBoxId = jsonData["chargeBoxId"].bool
    ////                    let amount = jsonData["amount"].int
    ////                    let stopValue = jsonData["stopValue"].string
    ////                    let totalTime = jsonData["totalTime"].string
    //                    let valueUnit = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["unit"].stringValue}
    //                    let value = jsonData.dictionaryValue["meterValues"]!.arrayValue.map {$0["value"].floatValue}
    //                    let timeBasedCharging = jsonData.dictionaryValue["timerBasedCharging"]!.boolValue
    //                    let totalTimeRemainingInMinutes = jsonData.dictionaryValue["totalTimeRemainingInMinutes"]!.intValue
    //                    let totalChargingTimeInMinutes = jsonData.dictionaryValue["chargingTimeInMinutes"]!.intValue
    //                    self.lblStartTime.text = startTime
    ////                    let orderUnit = UserAppStorage.unit
    //                    if valueUnit.count == 0 {
    //                       // self.timer?.invalidate()
    //                    }
    ////                    for wh in valueUnit{
    ////                        if wh == "Wh"{
    ////
    ////                            self.unitCons.append(contentsOf: value)
    ////                        }
    ////                        print(self.unitCons)
    ////                    }
    //                    if valueUnit.count > 0 {
    //                        for index in 0...(valueUnit.count - 1){
    //                            if valueUnit[index] == "Wh"{
    //
    //                                self.unitCons.append(value[index])
    //                            }
    //                            print(self.unitCons)
    //                        }
    //                    }
    //                        let cUnit = (self.unitCons.last ?? 0) - (self.unitCons.first ?? 0)
    ////                        let conUnit = value.last
    ////                    self.conUnit = cUnit / 1000
    //                        // print(conUnit)
    //                    self.lblUnitConsumed.text = "\(self.conUnit) Unit"
    //
    //                    if timeBasedCharging {
    //                        self.lblUnitPurchased.text = "\(totalTimeRemainingInMinutes)"
    //                        self.lblAmountPaid.text = "\(totalChargingTimeInMinutes)"
    //                        if  totalTimeRemainingInMinutes == 0 {
    //                            DispatchQueue.main.async {
    //                                self.callTrxStopApi()
    //                                print("Stop Charging")
    //                                //self.timer.invalidate()
    //                            }
    //                        }
    //                    } else {
    //                        if self.conUnit >= self.orderChargingUnitInWatt {
    //                            DispatchQueue.main.async {
    //                                self.callTrxStopApi()
    //                                print("Stop Charging")
    //                                //self.timer.invalidate()
    //                            }
    //                        }else{
    //                            print("Charging")
    //                        }
    //                    }
    //                }
    //                break
    //            case .failure:
    //                print(Error.self)
    //            }
    //        }
    //    }
    
    
    //    func callTrxStopApi(){
    //        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.trxStop
    //        let userPk = UserAppStorage.userPk
    //        let chrBoxId =  UserAppStorage.chrgBoxId
    //      //  LoadingOverlay.shared.showOverlay(view: view)
    //        let parameters = [
    //            "userTransactionId":String(userTransactionId),
    //            "chargeBoxIdentity":chargerBoxId
    //        ] as? [String:AnyObject]
    //        //    let parameters = [
    //        //        "userTransactionId":471,
    //        //        "chargeBoxIdentity":20210224013
    //        //            ] as? [String:AnyObject]
    ////        print(parameters)
    //        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { [self]
    //            response in
    //          //  LoadingOverlay.shared.hideOverlayView()
    //
    //            switch (response.result) {
    //
    //            case .success(let value):
    ////                print(response)
    //                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["chargingalert"])
    ////                let statusCode = response.response?.statusCode
    ////                print(statusCode!)
    //
    ////                let jsonData = JSON(value)
    ////                print(jsonData)
    ////                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
    //
    //                self.redirectToInvoicePage()
    //
    //                break
    //            case .failure:
    //                print(Error.self)
    //
    //            }
    //        }
    //    }
    
}
