//
//  ThanksVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/06/23.
//

import UIKit

class ThanksVC: UIViewController {

    @IBOutlet weak var lblRs: UILabel!
    
    @IBOutlet weak var btnProceed: UIButton!
    var INR = ""
    var amount = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
        self.lblRs.text = "INR: " + amount
       
    }
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = MenuNavigation.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
    

}
