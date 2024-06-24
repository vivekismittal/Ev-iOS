//
//  AvailableConnectorCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//  Corrected by Vivek Mittal on 4/06/2024


import UIKit

class AvailableConnectorTableViewCell: UITableViewCell {
    static let identifier = "AvailableConnectorTableViewCell"
    
    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblAvgRating: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblChargerName: UILabel!
    @IBOutlet weak var viewAvConnector: UIView!
    @IBOutlet weak var btnOpenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblOpen: UILabel!
    
    var chargeBoxId = [[String]]()
    var available = [[Bool]]()
    var distance = [String]()
    var maintenance = [Bool]()
    var stationId = [""]
    var chargerInfo: ChargerInformation?
    private var chargerStationConnectorInfosList = [ChargerStationConnectorInfos]()
    var openActionDelegate: OpenActionProtocol!
    
    var availableChargers:  AvailableChargers!{
        didSet{
            self.setData()
        }
    }
    
    private func setData(){
        DispatchQueue.global(qos: .userInteractive).async {[weak self] in
            guard let `self` = self else { return }
            
            self.chargerStationConnectorInfosList.removeAll()
            
            self.availableChargers.chargerInfos?.forEach({ chargerInfo in
                chargerInfo.chargerStationConnectorInfos?.forEach({ chargerConnector in
                    self.chargerStationConnectorInfosList.append(chargerConnector)
                })
            })
            self.chargerInfo = self.availableChargers.chargerInfos?.first
            DispatchQueue.main.async {
                self.setView()
            }
        }
    }
    
    private func setView(){
        let chargerConnInfo = chargerStationConnectorInfosList.first
        lblChargerName.text! = availableChargers?.chargerInfos?.first?.name ?? ""
        
        let startTiming = chargerConnInfo?.startTime ?? "12:00 AM"
        let endTiming = chargerConnInfo?.endTime ?? "12:00 PM"
        
        lblTiming.text! = startTiming + "-" + endTiming
        lblAddress.text! = chargerInfo?.chargerAddress?.street ?? ""
        
        btnOpen.layer.cornerRadius = 8
        btnOpen.isUserInteractionEnabled = false
        lblAvgRating.text = String((availableChargers.avgRating)!)
        let mantinance = availableChargers.maintenance
        if mantinance{
            lblOpen.text = "Under-maintenance"
        } else{
            lblOpen.text = "OPEN"
        }
        btnOpen.addTarget(self, action: #selector(openAction(sender:)), for: .touchUpInside)
        btnCall.addTarget(self, action: #selector(callAction(sender:)), for: .touchUpInside)
        
        collectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnPublic.layer.cornerRadius = 8
        self.viewAvConnector.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.viewAvConnector.layer.borderWidth = 1
        self.viewAvConnector.layer.cornerRadius = 8
        self.bcView.layer.cornerRadius = 12
        self.bcView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.bcView.layer.borderWidth = 1
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    @objc func openAction(sender: UIButton) {
        openActionDelegate.openChargingDetailVC(availableCharger: availableChargers)
    }
    
    
    @objc func callAction(sender: UIButton) {
        if let url = URL(string: "tel://\("8383070677")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

extension AvailableConnectorTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chargerStationConnectorInfosList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConnectorCollectionViewCell.identifier, for: indexPath)
        
        if let connectorCollectionViewCell = cell as? ConnectorCollectionViewCell{
            
            if let chargerConnectorInfo = self.chargerStationConnectorInfosList.element(at: indexPath.row){
                connectorCollectionViewCell.openActionDelegate = openActionDelegate
                connectorCollectionViewCell.chargerInfoName = chargerInfo?.name ?? ""
                connectorCollectionViewCell.chargerAddress = chargerInfo?.chargerAddress ?? ChargerAddress()
                connectorCollectionViewCell.chargerConnectorInfo = chargerConnectorInfo
            }
        }
        return cell
    }
    
}

protocol OpenActionProtocol{
    func openVC(_ vc: UIViewController)
    
    func openChargingDetailVC(availableCharger: AvailableChargers)
    
    func showToast(title: String, message: String)
    
    func startGuestUserSignupFlow()
    
    func connect(to chargerConnectorInfo: ChargerStationConnectorInfos, chargerInfoName: String?, streetAddress: String?)
}
