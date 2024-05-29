//
//  ChargingSessionVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 14/06/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChargingSessionVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var sessionTable: UITableView!
    var amount = [Int?]()
    var chargingStatus = [""]
    var stationName = [String?]()
    var userTransactionId = [Int]()
    var paymentTransactionId = [Int?]()
    var date = [String?]()
    var chargingCompleted = [Bool]()
    var boxID = [Int]()
    var connectorID = [Int]()
    //  var amount = [""]
    // var chargers = [ChargerInfo]()
    var name = [""]
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.trxMeterValuesApi()
    }
    
    // MARK: - Delegate & Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChargingSessionCell", for: indexPath) as? ChargingSessionCell
        //  cell?.layer.cornerRadius = 12
        cell?.lblTranId.text =  "Transaction ID: "  + String(paymentTransactionId[indexPath.row] ?? 0)
        cell?.lblDate.text = "Date: " + (date[indexPath.row] ?? "")
        cell?.lblAmount.text = "Amount: "  + String(amount[indexPath.row] ?? 0)
        cell?.lblStationName.text =  "Station Name: " + (stationName[indexPath.row] ?? "")
        if !chargingCompleted[indexPath.row] {
            cell?.lblCharging.textColor = UIColor.red
        }
        cell?.lblDistance.text = ""
        cell!.lblCharging.text! =  chargingStatus[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if amount[indexPath.row] == nil || amount[indexPath.row] == 0 {
            return 0
        }
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chargingCompleted[indexPath.row] {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TransactionDetailsVC") as! TransactionDetailsVC
            nextViewController.userTransactionId = String(userTransactionId[indexPath.row])
            nextViewController.isCommingFromTransactionList = true
            self.present(nextViewController, animated:true, completion:nil)
            
        }else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingVC") as! ChargingVC
            nextViewController.userTransactionId = userTransactionId[indexPath.row]
            nextViewController.chargerBoxId = String(boxID[indexPath.row])
            nextViewController.connName = String(connectorID[indexPath.row])
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    // MARK: - Action Method
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigationPoint") as! MenuNavigation
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // MARK: - API Call
    func trxMeterValuesApi(){
        let url  = EndPoints().baseUrlDev + EndPoints().paymentUsertrxsession
        let userPk = UserDefaults.standard.integer(forKey: "userPk")
      //  LoadingOverlay.shared.showOverlay(view: view)
        self.showSpinner(onView: view)
      
        let parameters = [
            "userPk":userPk
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(url, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
           // LoadingOverlay.shared.hideOverlayView()
            self.removeSpinner()
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                let amount = jsonData["userTrxSessions"].arrayValue.map {$0["amountDebited"].intValue}
                let chargingStatus = jsonData["userTrxSessions"].arrayValue.map {$0["chargingStatus"].stringValue}
                let chargingCompleted = jsonData["userTrxSessions"].arrayValue.map {$0["chargingCompleted"].boolValue}
                let stationName = jsonData["userTrxSessions"].arrayValue.map {$0["stationName"].stringValue}
                let userTransactionId = jsonData["userTrxSessions"].arrayValue.map {$0["userTransactionId"].intValue}
                let paymentTransactionId = jsonData["userTrxSessions"].arrayValue.map {$0["paymentTransactionId"].intValue}
                let boxID = jsonData["userTrxSessions"].arrayValue.map{ $0["chargeboxId"].intValue}
                let connectorID = jsonData["userTrxSessions"].arrayValue.map{ $0["connectorId"].intValue}
                let date = jsonData["userTrxSessions"].arrayValue.map {$0["date"].stringValue}
                for amt  in amount{
                    if  amt != 0{
                        self.amount.append(amt)
                    }
                }
                print(amount)
                print(chargingStatus)
                print(userTransactionId)
                //
               // self.amount = amount
                self.chargingStatus = chargingStatus
                self.stationName =   stationName
                self.userTransactionId = userTransactionId
                self.paymentTransactionId = paymentTransactionId
                self.date =   date
                self.chargingCompleted = chargingCompleted
                self.boxID = boxID
                self.connectorID = connectorID
                self.sessionTable.reloadData()
                // Remove local notification from app if all transaction is completed.
                if self.chargingCompleted.allSatisfy({$0}) {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["chargingalert"])
                }
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    
    /********************************* Unused Code **************************************
    func postApiCall(parameters:[String:Any],requestUrl:String){
        //   let url  = EndPoints().baseUrlDev + EndPoints().trxMeterValues
        guard let reqUrl = URL(string: requestUrl) else { return }
        print(reqUrl)
        
        let request = NSMutableURLRequest(url: reqUrl)
        //  uncomment this and add auth token, if your project needs.
        //  let config = URLSessionConfiguration.default
        //  let authString = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMywiUGFzc3dvcmQiOiIkMmEkMTAkYVhpVm9wU3JSLjBPYmdMMUk2RU5zdU9LQzlFR0ZqNzEzay5ta1pDcENpMTI3MG1VLzR3SUsiLCJpYXQiOjE1MTczOTc5MjV9.JaSh3FvpAxFxbq8z_aZ_4OhrWO-ytBQNu6A-Fw4pZBY"
        //  config.httpAdditionalHeaders = ["Authorization" : authString]
        
        let session = URLSession.shared
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        let task: Void = session.dataTask(with: request as URLRequest) { data, response, error in
            LoadingOverlay.shared.hideOverlayView()
            guard let data = data else { return }
            do {
                let gitData = try JSONDecoder().decode(SessionModel.self, from: data)
                print("response data:", gitData.error)
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
   
    */
}
enum NetworkError: Error {
    
    case domainError
    case decodingError
    case responseError
    case encodingError
}
