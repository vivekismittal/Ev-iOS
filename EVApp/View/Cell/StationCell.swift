//
//  StationCell.swift
//  EVApp
//
//  Created by Anoop Upadhyay on 17/09/23.
//

import UIKit

class StationCell: UITableViewCell {

    @IBOutlet var lbStationName: UILabel!
    @IBOutlet var lbAddress: UILabel!
    @IBOutlet var distance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
