//
//  AvailableConnectorsVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//  Corrected by Vivek Mittal on 4/06/2024
//

import UIKit

class AvailableConnectorsVC: UIViewController{
    
    var viewModel: AvailableChargersViewModel!
    
    @IBOutlet weak var chargerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    static func instantiateUsingStoryboard() -> Self {
        let availableChargerRepo = AvailableChargersRepo()
        let availableChargerViewModel = AvailableChargersViewModel(availableChargersRepo: availableChargerRepo)
        let availableChargerViewController =  ViewControllerFactory<AvailableConnectorsVC>.viewController(for: .AvailableCharger)
        availableChargerViewController.viewModel = availableChargerViewModel
        return availableChargerViewController as! Self
    }
    
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

extension AvailableConnectorsVC: UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.availableChargingStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AvailableConnectorTableViewCell.identifier, for: indexPath)
        
        if let availableConnectorTableViewCell = cell as? AvailableConnectorTableViewCell{
            availableConnectorTableViewCell.openActionDelegate = self
            availableConnectorTableViewCell.availableChargers = viewModel.availableChargingStations[indexPath.row]
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openChargingDetailVC(availableCharger: viewModel.availableChargingStations[indexPath.row])
    }
    

}

extension AvailableConnectorsVC: OpenActionProtocol{
    
    func openChargingDetailVC(availableCharger: AvailableChargers) {
        DispatchQueue.main.async {[weak self] in
            let nextVC = ChargingDetailVC.instantiateUsingStoryboard()
            
            DispatchQueue.global(qos: .userInteractive).async {[weak self] in
                
                nextVC.configure(with: availableCharger)
                
                DispatchQueue.main.async {
                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            
        }
    }
    
    func openVC(_ vc: UIViewController) {
        self.present(vc, animated: true, completion: nil)
    }
}
