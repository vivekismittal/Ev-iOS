//
//  ChargingTableViewCell.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 24/05/23.
//

import UIKit

class ChargingTableViewCell: UITableViewCell {
    @IBOutlet weak var imgCharger: UIImageView!
    @IBOutlet weak var lblCapacity: UILabel!
    
    @IBOutlet weak var btnBooking: UIButton!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var lblCoName: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDc: UILabel!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var bcView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        self.bcView.layer.borderColor =  #colorLiteral(red: 0.4919497967, green: 0.7860459685, blue: 0, alpha: 1)
        self.bcView.layer.borderWidth = 1
       // self.bcView.roundCorners([.topLeft, .topRight], radius: 15)
        self.btnStart.layer.cornerRadius = 8
        self.btnBooking.layer.cornerRadius = 8
        self.lblDc.layer.cornerRadius = 8
//        contentView.clipsToBounds = true
//        contentView.layer.cornerRadius = 15
//        contentView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
