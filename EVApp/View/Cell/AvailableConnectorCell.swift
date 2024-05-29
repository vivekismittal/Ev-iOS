//
//  AvailableConnectorCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit

class AvailableConnectorCell: UITableViewCell {

    @IBOutlet weak var lblTiming: UILabel!
    @IBOutlet weak var lblAvgRating: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bcView: UIView!
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblChargerName: UILabel!
    @IBOutlet weak var viewAvConnector: UIView!
    @IBOutlet weak var btnOpenWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblOpen: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.btnPublic.layer.cornerRadius = 8
        self.viewAvConnector.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.viewAvConnector.layer.borderWidth = 1
        self.viewAvConnector.layer.cornerRadius = 8
        self.bcView.layer.cornerRadius = 12
        self.bcView.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.bcView.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
