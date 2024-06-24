//
//  WaletVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 24/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class WalletVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var waletView: UIView!
    @IBOutlet weak var lblTransactionn: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblWalletAmount: UILabel!
    var  waletTransId = [""]
    var  createdDate = [""]
    var  amount = [""]
    var  transactionType = [""]
    var  paymentMode = [""]
    var   walletAmount =  ""
    
    static func instantiateUsingStoryboard() -> Self {
        let vc = ViewControllerFactory<Self>.viewController(for: .MyWalletScreen)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.waletView.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.waletView.layer.borderWidth = 2
        self.waletView.layer.cornerRadius = 12
        self.btnAdd.layer.cornerRadius = 8
       
        self.btnAdd.layer.cornerRadius = 12
        
        if waletTransId.count == 0{
            lblTransactionn.isHidden = false
        }else{
            lblTransactionn.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getWaletAmtApi()
        waletTransactionApi()
    }
    @IBAction func back(_ sender: Any) {
      // self.dismiss(animated: true)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = MenuNavigation.instantiateUsingStoryboard()
        self.present(nextViewController, animated:true, completion:nil)

    }
    
    @IBAction func addMoney(_ sender: Any) {
        let nextViewController = AddMoneyVC.instantiateUsingStoryboard()
        nextViewController.avaiBalance = self.walletAmount
        self.present(nextViewController, animated:true, completion:nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return waletTransId.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WaletTableViewCell", for: indexPath) as? WaletTableViewCell
        cell?.transId.text! =  "Transaction Id: " + waletTransId[indexPath.row]
        cell?.lblDate.text! = createdDate[indexPath.row]
        cell?.lblDc.text! = paymentMode[indexPath.row]
        cell?.lblAmount.text! = "₹" + amount[indexPath.row]
        cell?.lblTransType.text! = transactionType[indexPath.row] + " From Wallet"
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
extension WalletVC{
    func waletTransactionApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.waletTransaction
      //  LoadingOverlay.shared.showOverlay(view: view)
        self.showSpinner(onView: view)
      
        let userPk = UserAppStorage.userPk
            let parameters = [
                    "userPk":userPk
                    ] as? [String:AnyObject]
        print("userPk")
        print(parameters)
        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
             //   LoadingOverlay.shared.hideOverlayView()
          
            self.removeSpinner()
                        switch (response.result) {
                        case .success(let value):
                            print(response)
                    let statusCode = response.response?.statusCode
                            print(statusCode!)
                    let jsonData = JSON(value)
                            print(jsonData)
                           
                            let status = jsonData["status"].string
                            let message = jsonData["message"].string
                            let verified = jsonData["verified"].bool
                            let userWalletTransactionId = jsonData["list"].arrayValue.map {$0["userWalletTransactionId"].stringValue}
                            let createdDate = jsonData["list"].arrayValue.map {$0["createdDate"].stringValue}
                            let amount = jsonData["list"].arrayValue.map {$0["amount"].stringValue}
                            let walletAmount = jsonData["data"].dictionary.map {$0["amount"]!.stringValue}
                            let transactionType = jsonData["list"].arrayValue.map {$0["transactionType"].stringValue}
                            let paymentMode = jsonData["list"].arrayValue.map {$0["paymentMode"].stringValue}
                            
                            print(userWalletTransactionId)
                            
                            self.waletTransId = userWalletTransactionId
                            self.createdDate = createdDate
                            self.amount = amount
                            self.transactionType = transactionType
                            self.paymentMode = paymentMode
                            self.walletAmount  = walletAmount ?? "00"
                            self.lblWalletAmount.text = "₹" + (walletAmount ?? "00")
                            self.tableView.reloadData()
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
    func getWaletAmtApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.getWalletAmount
        let userPk = UserAppStorage.userPk
      //  LoadingOverlay.shared.showOverlay(view: view)
     //   self.showSpinner(onView: view)
      
            let parameters = [
                    "userPk": userPk
                    ] as? [String:AnyObject]
        
        print("userPk")
        print(parameters)
        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
            //    LoadingOverlay.shared.hideOverlayView()
           
         //   self.removeSpinner()
                        switch (response.result) {

                        case .success(let value):
                            print(response)
                            
                    let statusCode = response.response?.statusCode
                            print(statusCode!)
                            
                    let jsonData = JSON(value)
                            print(jsonData)
                           
                            let status = jsonData["status"].bool
                            let amount = jsonData["amount"].float
                            let userWalletAccountId = jsonData["userWalletAccountId"].double
//                            let userWalletTransactionId = jsonData["list"].arrayValue.map {$0["userWalletTransactionId"].stringValue}
//                            let createdDate = jsonData["list"].arrayValue.map {$0["createdDate"].stringValue}
//                            let amount = jsonData["list"].arrayValue.map {$0["amount"].stringValue}
//                            let walletAmount = jsonData["data"].dictionary.map {$0["amount"]!.stringValue}
//                            let transactionType = jsonData["list"].arrayValue.map {$0["transactionType"].stringValue}
//                            let paymentMode = jsonData["list"].arrayValue.map {$0["paymentMode"].stringValue}
//
                           // print(userWalletTransactionId)
                            
//                            self.waletTransId = userWalletTransactionId
//                            self.createdDate = createdDate
//                            self.amount = amount
//                            self.transactionType = transactionType
//                            self.paymentMode = paymentMode
//                            self.walletAmount  = walletAmount ?? "00"
//                            self.lblWalletAmount.text = "Rs. " + (walletAmount ?? "00")
//                            self.tableView.reloadData()
                            self.lblWalletAmount.text! = String(amount ?? 0.00)
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }

}
