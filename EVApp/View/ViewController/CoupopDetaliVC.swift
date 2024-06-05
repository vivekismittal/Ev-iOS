//
//  CoupopDetaliVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 12/06/23.
//

import UIKit

class CoupopDetaliVC: UIViewController {
    
    @IBOutlet weak var totalTax: UILabel!
    @IBOutlet weak var lblOrderAmt: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var lblCode: UILabel!
    
    @IBOutlet weak var codeView: UIView!
    @IBOutlet weak var lblAfterDiscount: UILabel!
    
    var discountValue = 0
    var couponCode = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblCode.text = couponCode
        self.lblDiscount.text = String(discountValue)
        self.lblOrderAmt.text = "110"
        self.lblAfterDiscount.text = "100"
        self.totalTax.text = "80"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.codeView.layer.borderWidth = 1
        self.codeView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.detailView.layer.borderWidth = 1
        self.detailView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.codeView.layer.cornerRadius = 15
        self.detailView.layer.cornerRadius = 15
        
    }

    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AvailableCouponVC") as! AvailableCouponVC
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
