//
//  StationCell.swift
//  EVApp
//
//  Created by Anoop Upadhyay on 17/09/23.
//

import UIKit

class StationCell: UITableViewCell {
    static let identifier = "StationCell"

    @IBOutlet var lbStationName: UILabel!
    @IBOutlet var lbAddress: UILabel!
    @IBOutlet var distance: UILabel!
    
    var availableCharger: AvailableChargers!{
        didSet{
            setViews()
        }
    }
    
    private func setViews(){
        selectionStyle = .none
        let chargersInfo = availableCharger.chargerInfos?.first
        lbStationName.text = chargersInfo?.name ?? ""
        lbAddress.text = chargersInfo?.chargerAddress?.street ?? ""
        distance.text = "Distance: " + LocationManager.shared.getDistance(from: availableCharger.stationChargerAddress ?? StationChargerAddress()).precisedString(upTo: 1) + "km"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
