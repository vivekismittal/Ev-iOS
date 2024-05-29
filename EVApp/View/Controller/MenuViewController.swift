//
//  MenuViewController.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit
import SideMenuSwift


class MenuViewController: UIViewController {
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var selectionMenuTrailingConstraint: NSLayoutConstraint!
    private var themeColor = UIColor.white
    
    var menuList  = ["Profile","Available Charger","Charging Sessions","My Bookings","My Wallet","Settings","Terms and Conditions","App Privacy Policy","Help","Logout","Delete Account"]
    
    var guest = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userFullName = UserDefaults.standard.string(forKey: "userFullName")
        self.lblUserName.text = userFullName
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let sideMenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sideMenuBasicConfiguration.position == .under) != (sideMenuBasicConfiguration.direction == .right)
        selectionMenuTrailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
    
}

extension MenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as? SideMenuTableViewCell
        menuCell!.lblMenu.text = menuList[indexPath.row]
        return menuCell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.present(nextViewController, animated:true, completion:nil)
        }else if indexPath.row == 1{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AvailableConnectorsVC") as! AvailableConnectorsVC
            //self.navigationController?.pushViewController(nextViewController, animated: false)
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if indexPath.row == 2{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingSessionVC") as! ChargingSessionVC
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if indexPath.row == 3{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
            self.present(nextViewController, animated:true, completion:nil)
            //let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DashboardVC") as? DashboardVC
            //self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else if indexPath.row == 4{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WaletVC") as! WaletVC
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if indexPath.row == 5{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if indexPath.row == 6{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TemsConditionVC") as! TemsConditionVC
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if indexPath.row == 7{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.present(nextViewController, animated:true, completion:nil)
        }
        else if indexPath.row == 8{
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
            self.present(nextViewController, animated:true, completion:nil)
        }
        
        else if indexPath.row == 9{
            //  showAlertController(titleOfAlert: "Alert", messageOfAlert: "Do you want to Logout?", doAction: gotoWelcome())
            let refreshAlert = UIAlertController(title: "Alert", message: "Do you want to Logout", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                UserDefaults.standard.setValue(nil, forKey: "userMobile")
                UserDefaults.standard.setValue(nil, forKey: "UserLogedIn")
                UserDefaults.standard.setValue(nil, forKey: "userFullName")
                UserDefaults.standard.setValue(nil, forKey: "userPk")
                UserDefaults.standard.setValue(nil, forKey: "chrgBoxId")
                UserDefaults.standard.synchronize()
                self.gotoWelcome()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
        else if indexPath.row == 10{
            //  showAlertController(titleOfAlert: "Alert", messageOfAlert: "Do you want to Logout?", doAction: gotoWelcome())
            let refreshAlert = UIAlertController(title: "Alert", message: "Do you want to Delete your account", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                UserDefaults.standard.setValue(nil, forKey: "userMobile")
                UserDefaults.standard.setValue(nil, forKey: "UserLogedIn")
                UserDefaults.standard.setValue(nil, forKey: "userFullName")
                UserDefaults.standard.setValue(nil, forKey: "userPk")
                UserDefaults.standard.setValue(nil, forKey: "chrgBoxId")
                UserDefaults.standard.synchronize()
                self.gotoWelcome()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        }
    }
    
    func gotoWelcome(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        self.present(nextViewController, animated:true, completion:nil)
    }
}
