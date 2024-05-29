//
//  PanelTableViewCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit

class PanelTableViewCell: UITableViewCell {

    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblDdetail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgType: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
