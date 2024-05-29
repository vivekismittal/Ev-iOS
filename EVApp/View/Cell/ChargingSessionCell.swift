//
//  ChargingSessionCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 14/06/23.
//

import UIKit

class ChargingSessionCell: UITableViewCell {
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var lblTranId: UILabel!
    @IBOutlet weak var lblCharging: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bcView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
