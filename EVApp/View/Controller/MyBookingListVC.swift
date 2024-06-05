//
//  MyBookingListVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyBookingListVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
  
    @IBOutlet weak var bookingTable: UITableView!
    
    var id = [String]()
    var bookingDate = [String]()
    var chargeBoxIdentity = [String]()
    var startTime = [String]()
    var endTime = [String]()
    var connectorId = [String]()
    var chargerAddress = [String]()
    var dataList = [String:Any]()
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    override func viewWillAppear(_ animated: Bool) {
        callBookingListApi()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBookingListCell", for: indexPath) as? MyBookingListCell
        cell?.btnCancel.tag = indexPath.row
        cell?.lblDate.text = " Date: " + bookingDate[indexPath.row]
        cell?.lblBookingId.text = "    Booking Id: " + id[indexPath.row]
        cell?.lblStationName.text = chargerAddress[indexPath.row]
        cell?.lblConnId.text = chargeBoxIdentity[indexPath.row] + ":" + connectorId[indexPath.row]
        cell?.lblTime.text = startTime[indexPath.row] + " to " + endTime[indexPath.row]
        cell?.btnCancel.addTarget(self, action: #selector(cancelApointment(sender:)), for: .touchUpInside)
       
        return cell!
    }
    func  tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
    }
    @objc func cancelApointment(sender: UIButton){
        let buttonTag = sender.tag
        let bookingId = id[buttonTag]
        print(bookingId)
        cancelBookingListApi(id: bookingId)
    }
}
extension MyBookingListVC{
    func callBookingListApi(){
        let userPk = UserDefaults.standard.integer(forKey: "userPk")
        let loginUrl  = EndPoints.shared.baseUrl +  EndPoints.shared.advbookingUserBookings
        self.showSpinner(onView: view)
    let parameters = [
        "userId":userPk
                    ] as? [String:AnyObject]
    print(parameters)
       
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
            self.removeSpinner()

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
                            
                            self.bookingTable.reloadData()
                           
                           
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
    func cancelBookingListApi(id:String){
        let userPk = UserDefaults.standard.integer(forKey: "userPk")
        let loginUrl  = EndPoints.shared.baseUrl +  EndPoints.shared.adbookingCancelBooking
        self.showSpinner(onView: view)
    let parameters = [
        "id":id
            ] as? [String:AnyObject]
    print(parameters)
       
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
            self.removeSpinner()

                        switch (response.result) {

                        case .success(let value):
                            //print(response)
                            
//                    let statusCode = response.response?.statusCode
//                            print(statusCode!)
                            
                    let jsonData = JSON(value)
                            print(jsonData)
//                        guard jsonData != nil else {
//                            self.showAlert(title: "Alert", message:"Data Not Found!")
//                            return
//                            }
                            let message = jsonData["message"].stringValue
                            self.showAlert(title: "", message: message)
//                            let bookingDate = jsonData.arrayValue.map {$0["bookingDate"].stringValue}
//                            let chargeBoxIdentity = jsonData.arrayValue.map {$0["chargeBoxIdentity"].stringValue}
//                            let startTime = jsonData.arrayValue.map {$0["startTime"].stringValue}
//                            let endTime = jsonData.arrayValue.map {$0["endTime"].stringValue}
//                            let connectorId = jsonData.arrayValue.map {$0["connectorId"].stringValue}
//                            let idTag = jsonData.arrayValue.map {$0["idTag"].stringValue}
//                            let chargerAddress = jsonData.arrayValue.map {$0["chargerInfo"].dictionaryValue}.map {$0["chargerAddress"]!.dictionaryValue}.map {$0["street"]?.stringValue ?? ""}
//                            self.id = id
//                            self.bookingDate = bookingDate
//                            self.chargeBoxIdentity = chargeBoxIdentity
//                            self.startTime = startTime
//                            self.endTime = endTime
//                            self.connectorId = connectorId
//                            self.chargerAddress = chargerAddress
//
//                            self.bookingTable.reloadData()
//
                           
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
