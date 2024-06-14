//
//  PanelTableViewCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit

class PanelTableViewCell: UITableViewCell {
    static let identifier = "PanelTableViewCell"

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblDdetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    
    var chargerName: String?
    var openActionDelegate: OpenActionProtocol!
    var chargerInfoName: String!
    var chargerAddress: ChargerAddress?
    
    var chargerConnectorInfo: ChargerStationConnectorInfos!{
        didSet{
            setViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setViews(){
        btnStart.layer.cornerRadius = 6
        btnStart.layer.masksToBounds = true
        
        switch chargerConnectorInfo.reason{
        case "Available":
            btnStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        case "Charger in use":
            btnStart.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case "UnderMaintenance":
            btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        default:
            btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            isUserInteractionEnabled = true
        }
      
        if chargerConnectorInfo.connectorType == "DC"{
            imgType.image = UIImage(named: "dc")
        } else{
            imgType.image = UIImage(named: "ac")
        }
        
        lblName.text = chargerName // chargersDetails?.chargeBoxId ?? "" + "-" + (stationDetails?.connectorId ?? "")
        lblDdetail.text = (chargerConnectorInfo.connectorType ?? "") + "kWh"
        btnStart.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func connected(sender: UIButton){
        
        let reason = chargerConnectorInfo.reason
        if reason == "Available"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingStationVC") as! ChargingStationVC
            
            nextViewController.stationId = chargerConnectorInfo.stationId ?? ""
            nextViewController.parkingPrice = String(chargerConnectorInfo.parkingPrice ?? 0)
            nextViewController.stationName = chargerInfoName ?? ""
            nextViewController.stationAddress = chargerAddress?.street ?? ""
            nextViewController.connName = chargerConnectorInfo.connectorNo ?? ""
            nextViewController.chargerBoxId = chargerConnectorInfo.chargeBoxId ?? ""
            nextViewController.type = chargerConnectorInfo.connectorType ?? ""
            nextViewController.price = String(chargerConnectorInfo.chargerPrice ?? 0)
            self.openActionDelegate.openVC(nextViewController)
        } else if reason == "Charger in use"{
            self.openActionDelegate.showToast(title: "Yahhvi", message: "Charger in use")
        } else if reason == "UnderMaintenance"{
            self.openActionDelegate.showToast(title: "Yahhvi", message: "Under Maintenance")
        } else{
            self.openActionDelegate.showToast(title: "Yahhvi", message: "Power Loss")
        }
    }

}
