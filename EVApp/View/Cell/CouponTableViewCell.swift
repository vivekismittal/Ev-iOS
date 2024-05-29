//
//  CouponTableViewCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 12/06/23.
//

import UIKit

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var lblOff: UILabel!
    @IBOutlet weak var btnApplyCoupon: UIButton!
    @IBOutlet weak var btnViewDetails: UIButton!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblCouponCode: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblOff.textAlignment = .right
       // rotateLabel.text = "TEXT"
      //  self.view.addSubview(lblOff)
        lblOff.transform = CGAffineTransform(rotationAngle: CGFloat(-(Double.pi / 2.0)))
        //lblOff.frame = CGRect(x:15, y:66, width:28, height:159)
        
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.contentView.layer.cornerRadius = 16
     
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
