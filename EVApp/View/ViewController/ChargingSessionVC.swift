//
//  ChargingSessionVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 14/06/23.
//  Corrected by Vivek Mittal

import UIKit

class ChargingSessionVC: UIViewController{
    
    @IBOutlet weak var sessionTable: UITableView!
    private var chargingSessionViewModel: UserChargingSessionViewModel!
    private var chargingSessions = [UserChargingSession](){
        didSet{
            DispatchQueue.main.async{
                self.sessionTable.reloadData()
            }
        }
    }
    
    static func instantiateUsingStoryboard() -> Self {
        let chargingSessionVC = ViewControllerFactory<Self>.viewController(for: .UserChargingSessionsScreen)
        chargingSessionVC.chargingSessionViewModel = UserChargingSessionViewModel()
        return chargingSessionVC
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sessionTable.showsVerticalScrollIndicator = false
        sessionTable.delegate = self
        sessionTable.dataSource = self
        self.getAllUserChargingSessions()
    }
    
    private func getAllUserChargingSessions(){
        self.showSpinner(onView: view)
        chargingSessionViewModel.getAllUserChargingSessions{[weak self] res in
            self?.removeSpinner()
            switch res{
            case .success(let data):
                guard let chargingSessions = data.userTrxSessions else { return }
                self?.chargingSessions = chargingSessions
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    // MARK: - Action Method
    @IBAction func back(_ sender: Any) {
        let nextViewController = MenuNavigation.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
}

// MARK: - Delegate & Data Source
extension ChargingSessionVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chargingSessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChargingSessionCell.identifier, for: indexPath)
        if let sessionCell = cell as? ChargingSessionCell{
            sessionCell.chargingSession = self.chargingSessions[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let session = chargingSessions[indexPath.row]
        if session.chargingCompleted == true {
            let nextViewController = TransactionDetailsVC.instantiateUsingStoryboard()
            nextViewController.userTransactionId = session.userTransactionId ?? ""
            nextViewController.isCommingFromTransactionList = true
            self.present(nextViewController, animated:true, completion:nil)
        } else {
            
            let nextViewController = ChargingVC.instantiateUsingStoryboard(
                ChargingVCModel(
                    orderChargingUnitInWatt: session.energyInWatts ?? 0,
                    orderChargingAmount: session.amount ?? 0,
                    connectorName: session.connectorId ?? "",
                    chargerBoxId: session.chargeboxId ?? "",
                    userTransactionId: session.userTransactionId ?? "",
                    timeBasedCharging: session.timerBasedCharging == true,
                    chargingTimeInMinutes: session.chargingTimeInMinutes ?? 0
                )
            )
            
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
}
