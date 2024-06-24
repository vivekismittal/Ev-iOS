//
//  ChargingSessionCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 14/06/23.
//

import UIKit

class ChargingSessionCell: UITableViewCell {
    static let identifier = "ChargingSessionCell"
    
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var lblTranId: UILabel!
    @IBOutlet weak var lblCharging: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var chargingSession: UserChargingSession!{
        didSet{
            lblTranId.text =  "Transaction ID: \(chargingSession.paymentTransactionId ?? 0)"
            lblDate.text = "Date: " + (chargingSession.date ?? "")
            lblAmount.text = "Amount: "  + (chargingSession.amountDebited?.rupeeString() ?? "NA")
            lblStationName.text =  "Station Name: " + (chargingSession.stationName ?? "")
            if chargingSession.chargingCompleted == false {
                lblCharging.textColor = UIColor.red
            }
            lblDistance.text = ""
            lblCharging.text = chargingSession.chargingStatus
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bcView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
