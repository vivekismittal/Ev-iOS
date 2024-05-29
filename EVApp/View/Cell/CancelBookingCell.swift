//
//  CancelBookingCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 02/07/23.
//

import UIKit

class CancelBookingCell: UITableViewCell {

    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var lblCacelled: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblConnId: UILabel!
    @IBOutlet weak var lblStationName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bcView.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.bcView.layer.borderWidth = 1
        self.bcView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
