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
        bcView.layer.cornerRadius = 5
        bcView.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        bcView.layer.borderWidth = 1
        btnStart.layer.cornerRadius = 5
        
        if chargerConnectorInfo?.connectorType == "DC" {
            imgConn.image = UIImage(named: "dc")
        } else{
            imgConn.image = UIImage(named: "ac")
        }
        
        lblPrice.text = (chargerConnectorInfo?.chargerPrice ?? 0).rupeeString() + " / Unit"
        
        lblConnector.text = (chargerConnectorInfo.connectorNo ?? "")
        lblType.text = chargerConnectorInfo?.connectorType
        
        switch chargerConnectorInfo?.reason{
        case .Available:
            btnStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        case .Charger_in_use:
            btnStart.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case .Under_Maintenance:
            btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        case .unknown(_), .none:
            btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            isUserInteractionEnabled = true
        }
        btnStart.addTarget(self, action: #selector(connected), for: .touchUpInside)
    }
    
    @objc func connected(){
        openActionDelegate.connect(to: chargerConnectorInfo, chargerInfoName: chargerInfoName, streetAddress: chargerAddress.street)
    }
}

