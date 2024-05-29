//
//  MyBookingListCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//

import UIKit

class MyBookingListCell: UITableViewCell {
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var lblBookingId: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblConnId: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnlocate: UIButton!
    @IBOutlet weak var lblStationName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bcView.layer.borderColor   = #colorLiteral(red: 0.3102734685, green: 0.7092829347, blue: 0.955113709, alpha: 1)
        self.bcView.layer.borderWidth = 1
        self.bcView.layer.cornerRadius = 15
        self.btnlocate.layer.cornerRadius = 8
        self.btnStart.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
