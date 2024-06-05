//
//  AvailableConnectorsVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//  Corrected by Vivek Mittal on 4/06/2024
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import CoreLocation


class AvailableConnectorsVC: UIViewController{
    
    var viewModel: AvailableChargersViewModel!
    
    @IBOutlet weak var chargerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - API Call
    func getData(){
        showSpinner(onView: view)
        viewModel.fetchSortedAvailableChargingStations{res in
            switch res{
            case .success(_):
                self.removeSpinner()
                DispatchQueue.main.async {
                    self.chargerTable.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension AvailableConnectorsVC: UITableViewDelegate, UITableViewDataSource, OpenActionProtocol{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableChargingStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AvailableConnectorTableViewCell.identifier, for: indexPath) as? AvailableConnectorTableViewCell
        
        cell?.openActionDelegate = self
        cell?.indexPathRow = indexPath.row
        cell?.availableChargers = viewModel.availableChargingStations[indexPath.row]
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openChargingDetailVC(indexPathRow: indexPath.row)
    }
    
    func openVC(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func openChargingDetailVC(indexPathRow: Int) {
        DispatchQueue.main.async {[weak self] in
            guard let `self` = self else { return }
            
            let nextVC = ViewControllerFactory.instantiateChargingDetailViewController()
            
            DispatchQueue.global(qos: .userInteractive).async {[weak self] in
                guard let `self` = self else { return }
                
                let availableCharger = viewModel.availableChargingStations[indexPathRow]
                
                var chargerStationConnectorInfosList = [ChargerStationConnectorInfos]()
                
                availableCharger.chargerInfos?.forEach({ chargerInfo in
                    chargerInfo.chargerStationConnectorInfos?.forEach({ chargerConnector in
                        chargerStationConnectorInfosList.append(chargerConnector)
                    })
                })
                
                
                nextVC.name = availableCharger.chargerInfos?.first?.name ?? ""
                nextVC.connectorName = chargerStationConnectorInfosList.map { $0.connectorNo ?? "" }
                nextVC.price = chargerStationConnectorInfosList.map { $0.chargerPrice ?? 0 }
                nextVC.connectorType = chargerStationConnectorInfosList.map { $0.connectorType ?? "" }
                nextVC.chargerBoxId = chargerStationConnectorInfosList.map { $0.chargeBoxId ?? "" }
                nextVC.available = chargerStationConnectorInfosList.map { $0.available }
                nextVC.maitinance = viewModel.availableChargingStations[indexPathRow].maintenance
                nextVC.stationId = viewModel.availableChargingStations[indexPathRow].stationId ?? ""
                nextVC.time = viewModel.availableChargingStations[indexPathRow].stationTimings ?? ""
                nextVC.availableCharger = "\(viewModel.availableChargingStations[indexPathRow].availableConnectors ?? 0)/ \(viewModel.availableChargingStations[indexPathRow].totalConnectors ?? 0)"
                nextVC.parkingCharges = chargerStationConnectorInfosList.map { $0.parkingPrice ?? 0 }
                nextVC.reason = chargerStationConnectorInfosList.map { $0.reason ?? "" }
                nextVC.distance = LocationManager.shared.getDistance(from: (viewModel.availableChargingStations[indexPathRow].stationChargerAddress)!)
                
                DispatchQueue.main.async {
                    self.present(nextVC, animated: true, completion: nil)
                }
            }
            
        }
    }
    
}
