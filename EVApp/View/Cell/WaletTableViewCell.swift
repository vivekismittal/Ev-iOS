//
//  WaletTableViewCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 24/05/23.
//

import UIKit

class WaletTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTransType: UILabel!
    @IBOutlet weak var lblDc: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var transId: UILabel!
    @IBOutlet weak var waletView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.waletView.layer.borderColor =  #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.waletView.layer.borderWidth = 2
        self.waletView.layer.cornerRadius = 12
       // self.contentView.roundCorners([.topLeft, .topRight], radius: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
