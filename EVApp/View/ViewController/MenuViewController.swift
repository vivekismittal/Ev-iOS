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
    
    var guest = true
    override func viewDidLoad() {
        super.viewDidLoad()
        let userFullName = UserAppStorage.userFullName
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
        return MenuItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier, for: indexPath)
        (menuCell as? SideMenuTableViewCell)?.lblMenu.text = MenuItems.allCases[indexPath.row].rawValue
        return menuCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch MenuItems.allCases[indexPath.row]
        {
        case .Profile:
            if UserAppStorage.isGuestUser{
                self.startGuestUserSignupFlow()
                return
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.present(nextViewController, animated:true, completion: nil)
            
            
        case .Available_Charger:
            let nextViewController = AvailableConnectorsVC.instantiateUsingStoryboard()
            self.navigationController?.pushViewController(nextViewController, animated: true)
            
        case .Charging_Sessions:
            if UserAppStorage.isGuestUser{
                self.startGuestUserSignupFlow()
                return
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingSessionVC") as! ChargingSessionVC
            self.present(nextViewController, animated: true, completion: nil)
            
        case .My_Bookings:
            if UserAppStorage.isGuestUser{
                self.startGuestUserSignupFlow()
                return
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MyBookingsVC") as! MyBookingsVC
            self.present(nextViewController, animated:true, completion:nil)
            
        case .My_Wallet:
            if UserAppStorage.isGuestUser{
                self.startGuestUserSignupFlow()
                return
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WaletVC") as! WaletVC
            self.present(nextViewController, animated:true, completion:nil)
            
        case .Settings:
            if UserAppStorage.isGuestUser{
                self.startGuestUserSignupFlow()
                return
            }
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            self.present(nextViewController, animated:true, completion:nil)
            
        case .Terms_and_Conditions:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TemsConditionVC") as! TemsConditionVC
            self.present(nextViewController, animated:true, completion:nil)
            
        case .App_Privacy_Policy:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.present(nextViewController, animated:true, completion:nil)
            
        case .Help:
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
            self.present(nextViewController, animated:true, completion:nil)
            
        case .Logout:
            let refreshAlert = UIAlertController(title: "Alert", message: "Do you want to Logout", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                UserAppStorage.reset()
                UserDefaults.standard.synchronize()
                self.gotoWelcome()
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            present(refreshAlert, animated: true, completion: nil)
            
        case .Delete_Account:
            let refreshAlert = UIAlertController(title: "Alert", message: "Do you want to Delete your account", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                UserAppStorage.reset()
                
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
        let nextViewController = WelcomeVC.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)
    }}

enum MenuItems: String, CaseIterable{
    case Profile
    case Available_Charger = "Available Charger"
    case Charging_Sessions = "Charging Sessions"
    case My_Bookings = "My Bookings"
    case My_Wallet = "My Wallet"
    case Settings
    case Terms_and_Conditions = "Terms and Conditions"
    case App_Privacy_Policy = "App Privacy Policy"
    case Help
    case Logout
    case Delete_Account = "Delete Account"
}
