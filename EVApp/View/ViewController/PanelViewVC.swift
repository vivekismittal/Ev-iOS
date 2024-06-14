//
//  PanelViewVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit

class PanelViewVC: UIViewController {
    @IBOutlet weak var lbNearbyCharger: UILabel!
    @IBOutlet weak var lbStationName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    var viewModel: AvailableChargersViewModel!
    
    var chargerStationConnectorInfos = [ChargerStationConnectorInfos]()
    
    var isShowStations: Bool {
        return stationID == nil
    }
    
    private var particularChargerIndex: Int?
    private var particularChargerName: String?
    private var particularChargerAddress: ChargerAddress?
    
    
    var stationID : String?
    let lock = NSLock()
    var reason : String?
    
    static func instantiateUsingStoryboard() -> Self {
        let panelVC = ViewControllerFactory<PanelViewVC>.viewController(for: .ChargerPanel)
        let availableChargerRepo = AvailableChargersRepo()
        let availableChargerViewModel = AvailableChargersViewModel(availableChargersRepo: availableChargerRepo)
        panelVC.viewModel = availableChargerViewModel
        return panelVC as! Self
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 30
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        if isShowStations{
            lbNearbyCharger.isHidden = false
        } else{
            lbNearbyCharger.isHidden = true
        }
        getData()
        
    }
    
    // MARK: - Set Data and View
    fileprivate func setData() {
        self.particularChargerIndex = self.viewModel.availableChargingStations.firstIndex(where: { $0.stationId == self.stationID })
        
        if !isShowStations,
           let index = self.particularChargerIndex,
           let partiularStation = self.viewModel.availableChargingStations.element(at: index){
            
            self.particularChargerName = partiularStation.chargerInfos?.first?.name
            self.particularChargerAddress = partiularStation.chargerInfos?.first?.chargerAddress
            self.chargerStationConnectorInfos.removeAll()
            
            partiularStation.chargerInfos?.forEach({ chargerInfo in
                chargerInfo.chargerStationConnectorInfos?.forEach({ chargerConnector in
                    self.chargerStationConnectorInfos.append(chargerConnector)
                })
            })
            
            DispatchQueue.main.async {
                self.lbStationName.text = partiularStation.chargerInfos?.first?.name ?? ""
                self.lblCount.text = "\(partiularStation.availableConnectors ?? 0)/\(partiularStation.totalConnectors ?? 0)"
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - API Call
    func getData(){
        showSpinner(onView: view)
        viewModel.fetchSortedAvailableChargingStations(sorted: isShowStations){[weak self] res in
            switch res{
            case .success(_):
                self?.removeSpinner()
                self?.setData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension PanelViewVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isShowStations{
            return viewModel.availableChargingStations.count
        }
        return chargerStationConnectorInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowStations{
            
            self.tableView.allowsSelection = true
            let cell = tableView.dequeueReusableCell(withIdentifier: StationCell.identifier, for: indexPath)
            if let stationCell = cell as? StationCell{
                stationCell.availableCharger = viewModel.availableChargingStations[indexPath.row]
            }
            return cell
        } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: PanelTableViewCell.identifier, for: indexPath)
            
            if let panelTableViewCell = cell as? PanelTableViewCell{
                panelTableViewCell.openActionDelegate = self
                panelTableViewCell.chargerInfoName = particularChargerName
                panelTableViewCell.chargerAddress = particularChargerAddress
                panelTableViewCell.chargerConnectorInfo = chargerStationConnectorInfos[indexPath.row]
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isShowStations{
            return 110
        }
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isShowStations{
            openChargingDetailVC(availableCharger: viewModel.availableChargingStations[indexPath.row])
        }
    }
}


extension PanelViewVC: OpenActionProtocol{
    func openVC(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
    
    func openChargingDetailVC(availableCharger: AvailableChargers) {
        DispatchQueue.main.async {[weak self] in
            let nextVC = ChargingDetailVC.instantiateUsingStoryboard()
            
            DispatchQueue.global(qos: .userInteractive).async {[weak self] in
                nextVC.configure(with: availableCharger)
                
                DispatchQueue.main.async {
                    self?.openVC(nextVC)
                }
            }
        }
    }
}
