//
//  StartChargingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 12/06/23.
//  Corrected by Vivek Mittal

import UIKit

class StartChargingVC: UIViewController {
    
    @IBOutlet weak var btnStartCharging: UIButton!
    
    var chargingData: ChargingVCModel!
    private var chargingViewModel: ChargingViewModel!
    
    static func instantiateUsingStoryboard(with chargingViewModel: ChargingViewModel = ChargingViewModel(), chargingData: ChargingVCModel) -> Self {
        let startChargingVC = ViewControllerFactory<Self>.viewController(for: .StartChargingScreen)
        startChargingVC.chargingViewModel = chargingViewModel
        startChargingVC.chargingData = chargingData
        return startChargingVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStartCharging.layer.cornerRadius = 12
    }
    
    @IBAction func back(_ sender: Any) {
        goBack()
    }
    
    @IBAction func startCharging(_ sender: Any) {
        startCharging()
    }
    
    func startCharging(){
        LoadingOverlay.shared.showOverlay(view: view)
        
        chargingViewModel.startCharging(connName: chargingData.connectorName, chargerBoxId: chargingData.chargerBoxId, timeBasedCharging: chargingData.timeBasedCharging, chargingTimeInMinutes: chargingData.chargingTimeInMinutes, orderChargingAmount: chargingData.orderChargingAmount){[weak self] res in
            
            DispatchQueue.main.async{
                LoadingOverlay.shared.hideOverlayView()
            }
            
            guard let self else { return }
            
            switch res{
            case .success(let data):
                guard let transactionId = data.userTransactionId else { return }
                
                DispatchQueue.main.async{
                    self.chargingData.userTransactionId = transactionId
                    let nextViewController = WaitingVC.instantiateUsingStoryboard(with: self.chargingViewModel,chargingData: self.chargingData)
                    self.present(nextViewController, animated:true, completion:nil)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

