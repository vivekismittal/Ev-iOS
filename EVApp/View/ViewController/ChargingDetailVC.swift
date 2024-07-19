//
//  ChargingDetailVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 24/05/23.
//

import UIKit

class ChargingDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var lblAmeneties: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalAvailableCharger: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var openReviewRatingScreen: UIView!
    
    private var name = ""
    private var address = ""
    private var stationTimings : String?
    private var chargerPointAmeneties = ""
    private var fromPanel = false
    private var distance = Float()
    private var rating = Double()
    private var stationId: String?
    
    private var maitinance = Bool()
    
    private var totalAvailableCharger = String()
    
    private var chargerStationConnectorInfosList = [ChargerStationConnectorInfos]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblDistance: UILabel!
    
    static func instantiateFromStoryboard(with availableCharger: AvailableChargers) -> Self {
        let chargingDetailVC = ViewControllerFactory<ChargingDetailVC>.viewController(for: .ChargingDetail)
        chargingDetailVC.configure(with: availableCharger)
        return chargingDetailVC as! Self
    }
    
    private func configure(with availableCharger: AvailableChargers){
        var availableConnectorCount = 0
        var totalConnectors = 0

        availableCharger.chargerInfos?.forEach({ chargerInfo in
            chargerInfo.chargerStationConnectorInfos?.forEach({ chargerConnector in
                chargerStationConnectorInfosList.append(chargerConnector)
                if chargerConnector.reason == .Available{
                    availableConnectorCount += 1
                }
                totalConnectors += 1
            })
        })
        stationId = availableCharger.stationId
        rating = availableCharger.avgRating ?? 0
        name = availableCharger.chargerInfos?.first?.name ?? ""
        maitinance = availableCharger.maintenance
        stationTimings = availableCharger.stationTimings ?? ""
        totalAvailableCharger = "\(availableConnectorCount) / \(totalConnectors)"
        distance = LocationManager.shared.getDistance(from: (availableCharger.stationChargerAddress)!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openReviewRatingScreen.setOnClickListener {
            if let stationId = self.stationId{
                let reviewRatingVC = ReviewsRatingViewController.instantiateFromStoryboard(for: stationId)
                reviewRatingVC.modalPresentationStyle = .fullScreen
                self.present(reviewRatingVC, animated: true, completion:nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblName.text = name
        self.lblAddress.text = address
        let amenities = chargerPointAmeneties.map { String($0) }
        _ = amenities.joined(separator: ",")
        print(chargerPointAmeneties)
        self.lblAmeneties.text = chargerPointAmeneties
        ratingLabel.text = String(rating)
        self.lblDistance.text = distance.precisedString(upTo: 2) + " Km"
        //        self.lblRating.text = rating
        lblTotalAvailableCharger.text = totalAvailableCharger
        lblTime.text = stationTimings
        if maitinance == true{
            self.showAlert(title: "Alert!", message: "This charge station is under maintenance, we will inform you once the maintenance is over. The inconvenience caused is deeply regretted.")
        }
    }
    
    @IBAction func back(_ sender: Any) {
        if let navigationController = self.navigationController{
            navigationController.popViewController(animated: true)
        } else{
            self.dismiss(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chargerStationConnectorInfosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChargingTableViewCell", for: indexPath) as? ChargingTableViewCell
        cell?.btnStart.tag = indexPath.row
        cell?.btnBooking.tag = indexPath.row
        
        
        cell?.btnStart.tag = indexPath.row
        
        cell?.btnStart.setOnClickListener {
            self.connect(to: self.chargerStationConnectorInfosList[indexPath.row], chargerInfoName: self.name, streetAddress: self.address)
        }
        
        switch chargerStationConnectorInfosList[indexPath.row].reason{
        case .Available:
            cell?.btnStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell?.view2.backgroundColor  = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            
            
        case .Charger_in_use:
            cell?.btnStart.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            cell?.view2.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            
        case .Under_Maintenance:
            cell?.btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.view2.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
        case .unknown(_), .none:
            cell?.btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.view2.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.isUserInteractionEnabled = true
        }
        
        if chargerStationConnectorInfosList[indexPath.row].connectorType == "DC" {
            cell?.imgCharger.image = UIImage(named: "dc")
        } else{
            cell?.imgCharger.image = UIImage(named: "ac")
        }
        
        cell?.lblName.text! =  chargerStationConnectorInfosList[indexPath.row].connectorNo ?? "NA"
        cell?.lblDc.text! =  chargerStationConnectorInfosList[indexPath.row].connectorType ?? ""
        
        
        cell?.lblPrice.text = (chargerStationConnectorInfosList[indexPath.row].chargerPrice ?? 0).rupeeString() + " / Unit"
        cell?.lblCoName.text! = "\(chargerStationConnectorInfosList[indexPath.row].connectorType ?? "NA") kWh"
        cell?.btnBooking.setOnClickListener {
            self.apointment(indexPathRow: indexPath.row)
        }
        
        return cell!
    }
    
    
    func apointment(indexPathRow: Int){
        if UserAppStorage.isGuestUser{
            self.startGuestUserSignupFlow()
            return
        }
        
        if let connectorName = chargerStationConnectorInfosList[indexPathRow].connectorNo,
            let chargeBoxId = chargerStationConnectorInfosList[indexPathRow].chargeBoxId {
            
            let nextViewController = BookApointmentVC.instantiateFromStoryboard(connectorName: connectorName, chargeBoxId: chargeBoxId)
            self.present(nextViewController, animated: true, completion:nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
