//
//  StationReviewCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 08/07/23.
//

import UIKit
import Cosmos


class StationReviewCell: UITableViewCell {
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var userStars: CosmosView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bcView.layer.cornerRadius = 15
        self.userStars.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
