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
    
    override func viewWillDisappear(_ animated: Bool) {
        timer?.invalidate()
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

extension UIDevice {
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}


