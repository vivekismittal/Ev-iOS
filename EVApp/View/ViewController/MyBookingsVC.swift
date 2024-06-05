//
//  MyBookingsVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//

import UIKit

class MyBookingsVC: UIViewController {
    var signUpResponse : CheckLoginSignUpModel?
    var userRoleResponse: UserRoleResponse?
    var userRoleResponseA : UserRoleResponse?
    let threeButtonViewModel: ThreeButtonViewModel = ThreeButtonViewModel()
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpCom: UIButton!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var upComView: UIView!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var cancelContainer: UIView!
    @IBOutlet weak var upComContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.upComContainer.isHidden = false
        self.cancelContainer.isHidden = true
        
        self.btnUpCom.layer.cornerRadius = 12
        self.btnCancel.layer.cornerRadius = 12
        segmentView.layer.cornerRadius = 12
        segmentView.layer.borderColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        segmentView.layer.borderWidth = 2
        
        btnUpCom.titleLabel?.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btnCancel.titleLabel?.textColor = .black
        self.btnUpCom.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        self.btnCancel.backgroundColor = .white
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func back(_ sender: Any) {
       self.dismiss(animated: true)

    }
    @IBAction func upcomingBooking(_ sender: Any) {
        self.upComContainer.isHidden = false
        self.cancelContainer.isHidden = true
        
        self.btnUpCom.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        self.btnCancel.backgroundColor = .white
        
        btnUpCom.titleLabel?.textColor = .white
        btnCancel.titleLabel?.textColor = .black
    }
    @IBAction func canceledBooking(_ sender: Any) {
        self.upComContainer.isHidden = true
        self.cancelContainer.isHidden = false
        
        self.btnUpCom.backgroundColor = .white
        self.btnCancel.backgroundColor = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
        
        btnUpCom.titleLabel?.textColor = .black
        btnCancel.titleLabel?.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

//    func checkIfLoginOrSignUp(_ mobileNumber: String) {
//        showSpinner(onView: view)
//        NetworkManager.inst.getApi("fetchbymobile/\(mobileNumber)") { data, error in
//            do {
//                guard let data = data else {return}
//                self.signUpResponse = try JSONDecoder().decode(CheckLoginSignUpModel.self, from: data)
//              let realId = self.signUpResponse?.rolefetch?.first?.realID ?? 0
//                let realId2 = self.signUpResponse?.rolefetch?.first?.createdBy
//                
//                print(self.signUpResponse?.rolefetch?.first?.realID ?? 0)
//               //print(self.signUpResponse?.mobilefetch?.first?.realID ?? 0)
//
//                
//                let brokerRollid = self.signUpResponse?.rolefetch?.first?.realID ?? 0
//             //  let mobilefetchReaiId = self.signUpResponse?.rolefetch?[1].realID ?? 0
//
//        
//                        
//                self.removeSpinner()
//                print(self.signUpResponse ?? 0)
//            } catch(let error) {
//                print(error.localizedDescription)
//                DispatchQueue.main.async { [weak self] in
//                    self?.removeSpinner()
//                    self?.showAlert(title: "", message: error.localizedDescription)
//                    
//                }
//            }
//        }
//    }
    
//    func callCreateRoleApi(roleId: UserType) {
//
//        showSpinner(onView: view)
//        NetworkManager.inst.postApi(params: threeButtonViewModel.createParamsForUserRole(roleId: roleId.rawValue), endPoint: "userrole") { data, error in
//            do {
//                guard let data = data else {return}
//                let json = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, AnyObject>
//                print(json)
//                let userRoleResponse : UserRoleResponse = try JSONDecoder().decode(UserRoleResponse.self, from: data)
//               // UserDefaults.existRoleRealId = userRoleResponse.USERROLE.real_id
//              //  print(UserDefaults.existRoleRealId ?? 0)
//                   // UserDefaults.userRole = userRoleResponse.USERROLE.user_code_pre
//                if let userRoleId = self.userRoleResponseA?.USERROLE {
//                    UserDefaults.standard.set(userRoleId.real_id, forKey: UserDefaultConstants.newUserRoleRealId.rawValue)
//                }
////                DispatchQueue.main.async { [weak self] in
////                    guard let `self` = self else {return}
////                    self.removeSpinner()
////                    switch roleId {
////                    case .tenant:
////
////                    case .broker:
////                        self.moveToDashBoardForBroker()
////                    case .landloard:
////                        self.moveToDashBoardForLandLord()
////                    }
////                 }
//
//            } catch {
//                print("error")
//            }
//        }
//    }

}
class ThreeButtonViewModel {
    
    func createParamsForUserRole(roleId: String) -> [String: Any] {
        var params: [String: Any] = [String: Any]()
        if let realId = UserDefaults.standard.value(forKey: UserDefaultConstants.realId.rawValue) as? Int {
            params = ["user_id" : realId,
                      "role_id" : Int(roleId) ?? 0,
                      "creator_id" : realId]
        }
        return params
    }
    
}
