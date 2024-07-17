//
//  AccountStatusVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 30/05/23.
//

import UIKit

class AccountStatusVC: UIViewController {

    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lbltitle: UILabel!
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserAppStorage.didUserLoggedIn = true
        UserDefaults.standard.synchronize()
        // Do any additional setup after loading the view.
        btnNext.layer.cornerRadius = 12
        //lbltitle.text = message
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showToast(title: "", message: message )
    }
    
    @IBAction func next(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = MenuNavigation.instantiateFromStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
