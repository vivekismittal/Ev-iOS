//
//  StartChargingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 12/06/23.
//  Corrected by Vivek Mittal

import UIKit

class StartChargingVC: UIViewController {
    
    @IBOutlet weak var btnStartCharging: UIButton!
    
    var connName = ""
    var chargerBoxId:String = ""
    var timeBasedCharging = false
    var chargingTimeInMinutes = 0
    var orderChargingAmount = Float()
    var orderChargingUnitInWatt = Float()
    private var chargingViewModel: ChargingUnitViewModel!
    
    static func instantiateUsingStoryboard(with chargingViewModel: ChargingUnitViewModel) -> Self {
        let startChargingVC = ViewControllerFactory<Self>.viewController(for: .StartChargingScreen)
        startChargingVC.chargingViewModel = chargingViewModel
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
        startCharging()
    }
    
    func startCharging(){
        LoadingOverlay.shared.showOverlay(view: view)
        chargingViewModel.startCharging(connName: connName, chargerBoxId: chargerBoxId, timeBasedCharging: timeBasedCharging, chargingTimeInMinutes: chargingTimeInMinutes, orderChargingAmount: orderChargingAmount){[weak self] res in
            DispatchQueue.main.async{
                LoadingOverlay.shared.hideOverlayView()
            }
            guard let self else { return }
            switch res{
            case .success(let data):
                guard let transactionId = data.userTransactionId else { return }
                DispatchQueue.main.async{
                    let nextViewController = WaitingVC.instantiateUsingStoryboard()
                    nextViewController.connName = self.connName
                    nextViewController.orderChargingAmount = self.orderChargingAmount
                    nextViewController.orderChargingUnitInWatt = self.orderChargingUnitInWatt
                    
                    nextViewController.chargerBoxId = self.chargerBoxId
                    nextViewController.userTransactionId = transactionId
                    self.present(nextViewController, animated:true, completion:nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
