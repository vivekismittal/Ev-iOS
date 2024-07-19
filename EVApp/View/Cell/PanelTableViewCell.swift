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
        case .Available:
            btnStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        case .Charger_in_use:
            btnStart.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case .Under_Maintenance:
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
        
        lblName.text = chargerName
        lblDdetail.text = (chargerConnectorInfo.connectorType ?? "") + "kWh"
        btnStart.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func connected(sender: UIButton){
        openActionDelegate.connect(to: chargerConnectorInfo, chargerInfoName: chargerInfoName, streetAddress: chargerAddress?.street)
    }

}
