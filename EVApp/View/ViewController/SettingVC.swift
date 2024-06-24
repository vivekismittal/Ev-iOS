//
//  SettingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 01/06/23.
//

import UIKit

class SettingVC: UIViewController {

    @IBOutlet weak var btnSwich: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = MenuNavigation.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func notificatioSwich(_ sender: Any) {
    }
    @IBAction func changePassword(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswwordVC") as! ChangePasswwordVC
        self.present(nextViewController, animated:true, completion:nil)
    }
  
}
