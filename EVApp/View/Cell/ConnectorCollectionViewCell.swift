//
//  CollectionConCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 17/06/23.
//
//  Corrected by Vivek Mittal on 4/06/2024


import UIKit

class ConnectorCollectionViewCell: UICollectionViewCell {
    static let identifier = "ConnectorCollectionViewCell"
    
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgConn: UIImageView!
    @IBOutlet weak var lblConnector: UILabel!
    
    var openActionDelegate: OpenActionProtocol!
    var chargerInfoName: String!
    var chargerAddress: ChargerAddress!
    var chargerConnectorInfo: ChargerStationConnectorInfos!{
        didSet{
            setViews()
        }
    }
    
    private func setViews(){
    //    self.cPrice = String(chargerConnInfo?.chargerPrice) ?? ""
        
    //    self.cPrice = String(self.charPrice[collectionView.tag][indexPath.row])
        
        
            bcView.layer.cornerRadius = 5
            bcView.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            bcView.layer.borderWidth = 1
            btnStart.layer.cornerRadius = 5

        if chargerConnectorInfo?.connectorType == "DC" {
            imgConn.image = UIImage(named: "dc")
        } else{
            imgConn.image = UIImage(named: "ac")
        }
        
        let priceRs = chargerConnectorInfo?.chargerPrice
    //    self.priceRs = priceRs
    //    cell?.lblPrice.text = "₹" + String(Float(chargerConnInfo?.chargerPrice ?? 0)) + "/Unit"

        
        let intPrice = Float((chargerConnectorInfo?.chargerPrice)!)
        lblPrice.text = "₹" + String(format: "%.2f", intPrice) + "/Unit"
        
        lblConnector.text = chargerConnectorInfo.chargeBoxId ?? "" + ":" + (chargerConnectorInfo.connectorNo ?? "")
        lblType.text = chargerConnectorInfo?.connectorType
        
        let reason = chargerConnectorInfo?.reason //available.first?[indexPath.row]
        if reason == "Available"{
            btnStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        }else if reason == "Charger in use"{
            btnStart.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        }else if reason == "UnderMaintenance"{
            btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        else{
            btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            isUserInteractionEnabled = true
        }
//       btnStart.accessibilityIdentifier = String(collectionView.tag)
//        cell?.btnStart.tag = indexPath.row
        btnStart.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
    }
    
    @objc func connected(sender: UIButton){
        
//        let intIndex = Int(sender.accessibilityIdentifier!)!
//        let chargersDetails:ChargerInformation? = viewModel.availableChargingStations[intIndex].chargerInfos?[0]
//        let chargerStationConnectorInfos = chargersDetails?.chargerStationConnectorInfos?[sender.tag]
//        print( self.cPrice)
        
        let reason = chargerConnectorInfo.reason
        if reason == "Available"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingStationVC") as! ChargingStationVC
            
            nextViewController.stationId = chargerConnectorInfo.stationId ?? ""
//            nextViewController.stationId = stationId[sender.tag]
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
            //                cell?.btnStart.isUserInteractionEnabled = false
        }
    }
}
