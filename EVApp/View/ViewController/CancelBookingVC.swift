//
//  CancelBookingVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 02/07/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class CancelBookingVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var cancelBookingTable: UITableView!
    
    var id = [String]()
    var bookingDate = [String]()
    var chargeBoxIdentity = [String]()
    var startTime = [String]()
    var endTime = [String]()
    var connectorId = [String]()
    var chargerAddress = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        callBookingCancelApi()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelBookingCell", for: indexPath) as? CancelBookingCell
        cell?.lblDate.text = "Date: " + bookingDate[indexPath.row]
       // cell?.lblBookingId.text = "Booking Id: " + id[indexPath.row]
        cell?.lblStationName.text = chargerAddress[indexPath.row]
        cell?.lblConnId.text = chargeBoxIdentity[indexPath.row] + ":" + connectorId[indexPath.row]
        cell?.lblTime.text = startTime[indexPath.row] + " to " + endTime[indexPath.row]
        //cell?.bcView.layer.cornerRadius  = 15
        return cell!
    }
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }

}
extension CancelBookingVC{
    func callBookingCancelApi(){
        let userPk = UserDefaults.standard.integer(forKey: "userPk")
        let loginUrl  = EndPoints.shared.baseUrl +  EndPoints.shared.advbookingUserCancelled
       // self.showSpinner(onView: view)
    let parameters = [
        "userId":userPk
                    ] as? [String:AnyObject]
    print(parameters)
       
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
          //  self.removeSpinner()

                        switch (response.result) {

                        case .success(let value):
                            //print(response)
                            
//                    let statusCode = response.response?.statusCode
//                            print(statusCode!)
                            
                    let jsonData = JSON(value)
                            print(jsonData)
                    let dataList = jsonData.arrayValue
                            print("JSONData:\(dataList)")
                            guard dataList.first != nil else {
                            self.showAlert(title: "Alert", message:"Data Not Found!")
                            return
                            }
                            let id = jsonData.arrayValue.map {$0["id"].stringValue}
                            let bookingDate = jsonData.arrayValue.map {$0["bookingDate"].stringValue}
                            let chargeBoxIdentity = jsonData.arrayValue.map {$0["chargeBoxIdentity"].stringValue}
                            let startTime = jsonData.arrayValue.map {$0["startTime"].stringValue}
                            let endTime = jsonData.arrayValue.map {$0["endTime"].stringValue}
                            let connectorId = jsonData.arrayValue.map {$0["connectorId"].stringValue}
                            let idTag = jsonData.arrayValue.map {$0["idTag"].stringValue}
                            let chargerAddress = jsonData.arrayValue.map {$0["chargerInfo"].dictionaryValue}.map {$0["chargerAddress"]!.dictionaryValue}.map {$0["street"]?.stringValue ?? ""}
                            self.id = id
                            self.bookingDate = bookingDate
                            self.chargeBoxIdentity = chargeBoxIdentity
                            self.startTime = startTime
                            self.endTime = endTime
                            self.connectorId = connectorId
                            self.chargerAddress = chargerAddress
                            
                            self.cancelBookingTable.reloadData()
                           
                           
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
