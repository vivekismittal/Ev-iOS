//
//  AddMmoneyVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 24/05/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import PayUBizCoreKit
import PayUCheckoutProBaseKit
import PayUCheckoutProKit
import PayUParamsKit

class AddMoneyVC: UIViewController {
    
    @IBOutlet weak var txtAmount: SkyFloatingLabelTextField!
    @IBOutlet weak var btnAddMoney: UIButton!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var addView4: UIView!
    @IBOutlet weak var addView3: UIView!
    @IBOutlet weak var addView2: UIView!
    @IBOutlet weak var addView1: UIView!
    @IBOutlet weak var lblAvailbalance: UILabel!
    var avaiBalance = ""
    var amount = 0
    let activityIndicator = ActivityIndicator()
    var surl: String = "http://cms.greenvelocity.co.in:8080/cms/manager/rest/payment/transaction-success"
    var furl: String = "http://cms.greenvelocity.co.in:8080/cms/manager/rest/payment/transaction-failure"
    var salt = "6PUiBWV9ifmIlGhabPPzkcOoApqWRkqQ"
    var key = "XpvgUb"
    var currentTime = Int64()
    
    static func instantiateFromStoryboard() -> Self {
        let vc = ViewControllerFactory<Self>.viewController(for: .AddMoneyScreen)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //   activityIndicator.startActivityIndicatorOn(self.view)
        applyShadowOnView(addView1)
        applyShadowOnView(addView2)
        applyShadowOnView(addView3)
        applyShadowOnView(addView4)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.btnAddMoney.layer.cornerRadius = 12
        self.lblAvailbalance.text = "Available Balance ₹: " + avaiBalance
        
        //        let when = DispatchTime.now() + 5.0
        //        DispatchQueue.main.asyncAfter(deadline: when){ [self] in
        //            self.activityIndicator.stopActivityIndicator()
        //        }
        DispatchQueue.main.async {
            self.getWaletAmtApi()
        }
        
        var date = NSDate()
        currentTime = Int64(date.timeIntervalSince1970 * 1000)
        print("Time in milliseconds is \(currentTime)")
    }
    
    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true)
    }
    
    @IBAction func addMoneyPressed(_ sender: Any) {
        let amt = Int(self.txtAmount.text ?? "0")!
        guard amt > 299 else {
            showAlert(title: "Alert", message: "Minimum amount should be  ₹300")
            return
        }
        let payUConfig = PayUCheckoutProConfig()
        addCheckoutProConfigurations(config: payUConfig)
        PayUCheckoutPro.open(on: self, paymentParam: getPaymentParam(), config: payUConfig, delegate: self)
        
    }
    @IBAction func btn500Action(_ sender: Any) {
        self.amount = 500
        self.txtAmount.text  = String(amount)
    }
    
    @IBAction func btn1000Action(_ sender: Any) {
        // self.txtAmount.text  = "Rs.1000"
        self.amount = 1000
        self.txtAmount.text  = String(amount)
    }
    @IBAction func btn1500Action(_ sender: Any) {
        // self.txtAmount.text  = "Rs.1500"
        self.amount = 1500
        self.txtAmount.text  = String(amount)
    }
    @IBAction func btn2000Action(_ sender: Any) {
        // self.txtAmount.text  = "Rs.2000"
        self.amount = 2000
        self.txtAmount.text  = String(amount)
    }
    
    //    func applyShadowOnView(_ view: UIView) {
    //        view.layer.cornerRadius = 18
    //        view.center = self.view.center
    //        view.backgroundColor = #colorLiteral(red: 0.4901960784, green: 0.7882352941, blue: 0, alpha: 1)
    //        view.layer.shadowColor = UIColor.gray.cgColor
    //        view.layer.shadowOpacity = 0.8
    //        view.layer.shadowOffset = CGSize.zero
    //        view.layer.shadowRadius = 5
    //
    //    }
    
}
extension AddMoneyVC{
    func addWaletAmtApi(amt:String,mode:String,AddOn:String,id:String){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.addWaletAmt
        self.showSpinner(onView: view)
       
        let parameters = [
            "userPk":UserAppStorage.userPk,
            "amount": amt,
            "status":"true",
            "transactionType": "Credit",
            "paymentTransactionId": AddOn,
            "paymentMode": mode
        ] as? [String:AnyObject]
        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
         
            self.removeSpinner()
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                let status = jsonData["status"].bool
                let message = jsonData["message"].string
                // self.showToast(title: "", message: message ?? "NA")
                DispatchQueue.main.async {
                    self.getWaletAmtApi()
                }
                
                DispatchQueue.main.async {
                    //                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    //                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WaletVC") as! WaletVC
                    //                                self.present(nextViewController, animated:true, completion:nil)
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "ThanksVC") as! ThanksVC
                    nextVC.amount = self.txtAmount.text ?? "0"
                    self.present(nextVC, animated:true, completion:nil)
                }
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    func getWaletAmtApi(){
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.getWalletAmount
        let userPk = UserAppStorage.userPk
        self.showSpinner(onView: view)
       
    //    LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "userPk": userPk
        ] as? [String:AnyObject]
        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            //LoadingOverlay.shared.hideOverlayView()
           
            self.removeSpinner()
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
                self.lblAvailbalance.text = "Available Balance ₹: " + String(amount ?? 0)
                
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
}
extension AddMoneyVC: PayUCheckoutProDelegate{
    
    private func getPaymentParam() -> PayUPaymentParam {
        let userMobile = UserAppStorage.userMobile
        let eMail = UserAppStorage.email
        let userFullName = UserAppStorage.userFullName
        let paymentParam = PayUPaymentParam(key: "XpvgUb",
                                            transactionId: String(currentTime),
                                            amount: txtAmount.text ?? "0" ,
                                            //  amount:"1" ,
                                            productInfo: "EVCharging",
                                            firstName: userFullName ?? "",
                                            email: eMail ?? "",
                                            phone: userMobile ?? "",
                                            surl: surl,
                                            furl: furl,
                                            environment: Environment.production)
        print("Params: \(paymentParam)")
        return paymentParam
    }
    func onError(_ error: Error?) {
        // handle error scenario
        navigationController?.popToViewController(self, animated: true)
        print("payment Error")
        print(error?.localizedDescription ?? "")
        showAlertPayu(title: "Error", message: error?.localizedDescription ?? "")
        
    }
    
    func onPaymentSuccess(response: Any?) {
        // handle success scenario
        let jsonData = JSON(response as Any)
        print(jsonData)
        let payRes = jsonData["payuResponse"].stringValue
        var status = ""
        print(payRes)
        
        do{
            if let json = payRes.data(using: String.Encoding.utf8){
                if let jsonData = try JSONSerialization.jsonObject(with: json, options: .allowFragments) as? [String:AnyObject]{
                    var id = "0"
                    id = String(jsonData["id"] as? Int ?? 0)
                    
                    if id == "0"{
                        id = jsonData["txnid"] as? String ?? "0"
                    }
                    
                    let mode = jsonData["mode"] as! String
                    let addedon = jsonData["addedon"] as! String
                    let amount = jsonData["amount"] as! String
                    var paymentStatus = jsonData["status"] as! String
                    status = paymentStatus
                    print(id)
                    print(mode)
                    print(addedon)
                    DispatchQueue.main.async {
                        self.addWaletAmtApi(amt: amount, mode: mode, AddOn: addedon, id: id )
                    }
                    
                }
            }
        }catch {
            print(error.localizedDescription)
            
        }
        navigationController?.popToViewController(self, animated: true)
        print("payment Success")
        //    showAlertPayu(title: "Payent", message: status)
        
    }
    
    func onPaymentFailure(response: Any?) {
        // handle failure scenario
        navigationController?.popToViewController(self, animated: true)
        showAlertPayu(title: "Failure", message: "\(response ?? "")")
        print("payment Failure")
        print("response\n", response ?? "")
    }
    
    func onPaymentCancel(isTxnInitiated: Bool) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddMmoneyVC") as! AddMoneyVC
////        self.present(nextViewController, animated:true, completion:nil)
//        // handle txn cancelled scenario
//        // isTxnInitiated == YES, means user cancelled the txn when on reaching bankPage
//        // isTxnInitiated == NO, means user cancelled the txn before reaching the bankPage
//        navigationController?.popToViewController(nextViewController, animated: true)
        print("payment Cancelled")
        let completeResponse = "isTxnInitiated = \(isTxnInitiated)"
        showAlertPayu(title: "Cancelled", message: "\(completeResponse)")
        
    }
    func generateHash(for param: DictOfString, onCompletion: @escaping PayUHashGenerationCompletion) {
        
        let commandName = (param[HashConstant.hashName] ?? "")
        //
        //          let hashStringWithoutSalt = (param[HashConstant.hashString] ?? "")
        //
        //          let postSalt = param[HashConstant.postSalt]
        //        debugPrint("hashStringWithoutSalt.......\(hashStringWithoutSalt)")
        //          var hashValue = ""
        //
        //          if let hashType = param[HashConstant.hashType], hashType == HashConstant.V2 {
        //
        //              hashValue = PayUDontUseThisClass.hmacSHA256(hashStringWithoutSalt, withKey: salt)
        //          }
        //        else if commandName == HashConstant.mcpLookup {
        //
        //              hashValue = Utils.hmacsha1(of: hashStringWithoutSalt, secret: (key))
        //
        //          } else if let postSalt = postSalt {
        //
        //              let hashString = hashStringWithoutSalt + (salt) + postSalt
        //
        //              hashValue = Utils.sha512Hex(string: hashString)
        //
        //              print("POST SALT..........\(hashString)")
        //
        //          } else {
        //
        //              hashValue = Utils.sha512Hex(string: (hashStringWithoutSalt + (salt)))
        //
        //          }
        //        debugPrint("hashValue.......\(hashValue)")
        var payment_hash = ""
        let hashStringWithoutSalt = (param[HashConstant.hashString] ?? "")
        let verifyOtp  = EndPoints.shared.baseUrlDev + EndPoints.shared.paymentHash
        let userPk = UserAppStorage.userPk
        LoadingOverlay.shared.showOverlay(view: view)
        let parameters = [
            "hashData": hashStringWithoutSalt
        ] as? [String:AnyObject]
        AF.request(verifyOtp, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            LoadingOverlay.shared.hideOverlayView()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                payment_hash = jsonData["payment_hash"].stringValue
                //payment_hash = payment_hash
                // onCompletion([commandName : payment_hash])
                print("payment_hash")
                print(payment_hash)
                onCompletion([commandName : payment_hash])
                break
            case .failure:
                print(Error.self)
                
            }
        }
        
        // onCompletion([commandName : payment_hash])
        
    }
    func showAlertPayu(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func addCheckoutProConfigurations(config: PayUCheckoutProConfig) {
        config.merchantName = "EVcharging"
        config.merchantLogo = UIImage(named: "logo.png")
    }
    
}
extension String {
    func toData() -> Data {
        return Data(self.utf8)
    }
}
