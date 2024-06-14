//
//  BookApointmentVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 02/07/23.
//

import UIKit
import Alamofire
import SwiftyJSON

class BookApointmentVC: UIViewController {
    @IBOutlet weak var viewGreen: UIView!
    
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    @IBOutlet weak var btnT4: UIButton!
    @IBOutlet weak var btnT3: UIButton!
    @IBOutlet weak var btnT2: UIButton!
    @IBOutlet weak var btnT1: UIButton!
    @IBOutlet weak var btnDate4: UIButton!
    @IBOutlet weak var btnDate3: UIButton!
    @IBOutlet weak var btndate2: UIButton!
    @IBOutlet weak var btnDate1: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var viewRed: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var lblSelectedSession: UILabel!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var lblEndTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    var id = [String]()
    var bookingDate = [String]()
    var chargeBoxIdentity = [String]()
//    var startTime = [String]()
//    var endTime = [String]()
   var connectorId = [String]()
   var selectedDate = String()
    var sTime = String()
    var eTime = String()
    var date = [JSON]()
    var chargeBoxId = String()
    var connName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblSelectedSession.text = "30 Min"
        self.view1.layer.cornerRadius = self.view1.bounds.height / 2
        self.view2.layer.cornerRadius = self.view2.bounds.height / 2
        self.view3.layer.cornerRadius = self.view3.bounds.height / 2
        self.view4.layer.cornerRadius = self.view4.bounds.height / 2
        self.view5.layer.cornerRadius = self.view5.bounds.height / 2
        self.view6.layer.cornerRadius = self.view6.bounds.height / 2
        self.viewGreen.layer.cornerRadius = self.viewGreen.bounds.height / 2
        self.viewRed.layer.cornerRadius = self.viewRed.bounds.height / 2
//        self.startTime.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        self.startTime.layer.borderWidth = 1
//        self.endTime.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        self.endTime.layer.borderWidth = 1
        
        bottomView.clipsToBounds = true
        bottomView.layer.cornerRadius = 25
        btnNext.layer.cornerRadius = 12
        bottomView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.bottomView.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.bottomView.layer.borderWidth = 1
        self.lblSelectedSession.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.lblSelectedSession.layer.borderWidth = 1
        
        self.btnDate1.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btnDate1.layer.borderWidth = 1
        self.btndate2.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btndate2.layer.borderWidth = 1
        self.btnDate3.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btnDate3.layer.borderWidth = 1
        self.btnDate4.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btnDate4.layer.borderWidth = 1
//        self.btnTime1.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        self.btnTime1.layer.borderWidth = 1
//        self.btnTime2.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//        self.btnTime2.layer.borderWidth = 1
        btnDate1.layer.cornerRadius = 12
        btndate2.layer.cornerRadius = 12
        btnDate3.layer.cornerRadius = 12
        btnDate4.layer.cornerRadius = 12
        btnT1.layer.cornerRadius = 12
        btnT2.layer.cornerRadius = 12
        btnT3.layer.cornerRadius = 12
        btnT4.layer.cornerRadius = 12
//        btnTime1.layer.cornerRadius = 12
//        btnTime2.layer.cornerRadius = 12
    
        
        self.btnT1.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btnT1.layer.borderWidth = 1
        self.btnT2.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btnT2.layer.borderWidth = 1
        self.btnT3.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btnT3.layer.borderWidth = 1
        self.btnT4.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.btnT4.layer.borderWidth = 1
        
        callSlotApi()
      
        getstartTimeFrom(date: startTime.date)
        getendTimeFrom(date: endTime.date)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func next(_ sender: Any) {
        advBookslots()
    }
    
    @IBAction func startTime(_ sender: Any) {
        getstartTimeFrom(date: startTime.date)
    }
    @IBAction func endTime(_ sender: Any) {
        getendTimeFrom(date: endTime.date)
    }
    
    func getstartTimeFrom(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.string(from: date)
        self.sTime = time
        print(self.sTime)
    }
    func getendTimeFrom(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.timeZone = TimeZone.current
        let time = dateFormatter.string(from: date)
        self.eTime = time
        print(self.eTime)
    }
    @IBAction func date1(_ sender: Any) {
        btndate2.isSelected = false
        btnDate3.isSelected = false
        btnDate4.isSelected = false
        if btnDate1.isSelected {
            btnDate1.isSelected = false
            self.btnDate1.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btnDate1.layer.borderWidth = 1
               }else {
                   self.selectedDate = date[0].stringValue
                   btnDate1.isSelected = true
                   self.btnDate1.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btnDate1.layer.borderWidth = 2
                }
    }
    @IBAction func date2(_ sender: Any) {
        btnDate1.isSelected = false
        btnDate3.isSelected = false
        btnDate4.isSelected = false
        if btndate2.isSelected {
            btndate2.isSelected = false
            self.btndate2.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btndate2.layer.borderWidth = 1
               }else {
                   self.selectedDate = date[1].stringValue
                   btndate2.isSelected = true
                   self.btndate2.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btndate2.layer.borderWidth = 2
                }
    }
    @IBAction func date3(_ sender: Any) {
        btndate2.isSelected = false
        btnDate1.isSelected = false
        btnDate4.isSelected = false
        if btnDate3.isSelected {
            btnDate3.isSelected = false
            self.btnDate3.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btnDate3.layer.borderWidth = 1
               }else {
                   self.selectedDate = date[2].stringValue
                   btnDate3.isSelected = true
                   self.btnDate3.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btnDate3.layer.borderWidth = 2
                }
    }
    @IBAction func date4(_ sender: Any) {
        btndate2.isSelected = false
        btnDate3.isSelected = false
        btnDate1.isSelected = false
        if btnDate4.isSelected {
            btnDate4.isSelected = false
            self.btnDate4.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btnDate4.layer.borderWidth = 1
               }else {
                   self.selectedDate = date[3].stringValue
                   btnDate4.isSelected = true
                   self.btnDate4.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btnDate4.layer.borderWidth = 2
                }
    }
//    @IBAction func timer1(_ sender: Any) {
//        if btnTime1.isSelected {
//            btnTime1.isSelected = false
//            self.btnTime1.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//            self.btnTime1.layer.borderWidth = 1
//               }else {
//                   btnTime1.isSelected = true
//                   self.btnTime1.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
//                   self.btnTime1.layer.borderWidth = 2
//                }
//    }
//    @IBAction func timer2(_ sender: Any) {
//        if btnTime2.isSelected {
//            btnTime2.isSelected = false
//            self.btnTime2.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
//            self.btnTime2.layer.borderWidth = 1
//               }else {
//                   btnTime2.isSelected = true
//                   self.btnTime2.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
//                   self.btnTime2.layer.borderWidth = 2
//                }
//    }
    @IBAction func T1(_ sender: Any) {
        btnT2.isSelected = false
        btnT3.isSelected = false
        btnT4.isSelected = false
        if btnT1.isSelected {
            btnT1.isSelected = false
            self.btnT1.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btnT1.layer.borderWidth = 1
               }else {
                   btnT2.isSelected = false
                   self.lblSelectedSession.text = "15 Min"
                   btnT1.isSelected = true
                   self.btnT1.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btnT1.layer.borderWidth = 2
                }
    }
    @IBAction func T2(_ sender: Any) {
        btnT1.isSelected = false
        btnT3.isSelected = false
        btnT4.isSelected = false
        if btnT2.isSelected {
            btnT2.isSelected = false
            self.btnT2.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btnT2.layer.borderWidth = 1
               }else {
                   self.lblSelectedSession.text = "30 Min"
                   btnT2.isSelected = true
                   self.btnT2.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btnT2.layer.borderWidth = 2
                }
    }
    @IBAction func T3(_ sender: Any) {
        btnT2.isSelected = false
        btnT1.isSelected = false
        btnT4.isSelected = false
        if btnT3.isSelected {
            btnT3.isSelected = false
            self.btnT3.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btnT3.layer.borderWidth = 1
               }else {
                   self.lblSelectedSession.text = "1 Hour"
                   btnT3.isSelected = true
                   self.btnT3.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btnT3.layer.borderWidth = 2
                }
    }
    @IBAction func T4(_ sender: Any) {
        btnT2.isSelected = false
        btnT3.isSelected = false
        btnT1.isSelected = false
        if btnT4.isSelected {
            btnT4.isSelected = false
            self.btnT4.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.btnT4.layer.borderWidth = 1
               }else {
                   self.lblSelectedSession.text = "2 Hour"
                   btnT4.isSelected = true
                   self.btnT4.layer.borderColor   = #colorLiteral(red: 0.4855932593, green: 0.7739699483, blue: 0.08541054279, alpha: 1)
                   self.btnT4.layer.borderWidth = 2
                }
    }
    @IBAction func viewBookedSlots(_ sender: Any) {
    }
    
}
extension BookApointmentVC{
    func callSlotApi(){
        let userPk = UserAppStorage.userPk
        let loginUrl  = EndPoints.shared.baseUrlDev + EndPoints.shared.advancebookingTimeslots
        self.showSpinner(onView: view)
    let parameters = [
        "chargeBoxIdentity":userPk
                    ] as? [String:AnyObject]
    print(parameters)
       
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
            self.removeSpinner()
                switch (response.result) {
                case .success(let value):
                    let jsonData = JSON(value)
                            print(jsonData)
             
//                    guard dataList.first != nil else {
//                            self.showAlert(title: "Alert", message:"Data Not Found!")
//                            return
//                            }
                            let currentTime = jsonData["currentTime"].stringValue
                            let todayDate = jsonData["todayDate"].stringValue
                            let bookingDate = jsonData["dates"].arrayValue
                    
                   // let chargeBoxId = jsonData["chargerInfo"].dictionary.map {$0["chargeBoxId"]?.stringValue}
//                            let startTime = jsonData.arrayValue.map {$0["startTime"].stringValue}
//                            let endTime = jsonData.arrayValue.map {$0["endTime"].stringValue}
//                            let connectorId = jsonData.arrayValue.map {$0["connectorId"].stringValue}
//                            let idTag = jsonData.arrayValue.map {$0["idTag"].stringValue}
//                            let chargerAddress = jsonData.arrayValue.map {$0["chargerInfo"].dictionaryValue}.map {$0["chargerAddress"]!.dictionaryValue}.map {$0["street"]?.stringValue ?? ""}
                   // self.chargeBoxId = chargeBoxId ?? ""
                    self.date = bookingDate
                    self.btnDate1.setTitle(bookingDate[0].string, for: .normal)
                    self.btndate2.setTitle(bookingDate[1].string, for: .normal)
                    self.btnDate3.setTitle(bookingDate[2].string, for: .normal)
                    self.btnDate4.setTitle(bookingDate[3].string, for: .normal)
                    self.lblTime.text = currentTime
                    self.lblDate.text = todayDate
                    self.lblEndTime.text = currentTime
                    self.lblEndDate.text = todayDate

                           
                           
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
func advBookslots(){
    let userPk = UserAppStorage.userPk
    let loginUrl  = EndPoints.shared.baseUrlDev + EndPoints.shared.advBookslots
    self.showSpinner(onView: view)
    let parameters = [
        "userId":userPk,
        "startTime": self.sTime,
        "endTime":self.eTime,
        "bookingDate":self.selectedDate,
        "bookingAmount":150,
        "connectorId":connName,
        "idTag":"tag001",
        "chargeBoxIdentity": self.chargeBoxId
                    ] as? [String:AnyObject]
    print(parameters)
       
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
                    response in
            self.removeSpinner()
                switch (response.result) {
                case .success(let value):
                    let jsonData = JSON(value)
                            print(jsonData)
                    let message = jsonData["message"].stringValue
                    let status = jsonData["status"].stringValue
                    self.showAlert(title: "", message:message)
                   
//                            let currentTime = jsonData["currentTime"].stringValue
//                            let todayDate = jsonData["todayDate"].stringValue
//                            let bookingDate = jsonData["dates"].arrayValue
//                            let chargeBoxIdentity = jsonData.arrayValue.map {$0["chargeBoxIdentity"].stringValue}
//                            let startTime = jsonData.arrayValue.map {$0["startTime"].stringValue}
//                            let endTime = jsonData.arrayValue.map {$0["endTime"].stringValue}
//                            let connectorId = jsonData.arrayValue.map {$0["connectorId"].stringValue}
//                            let idTag = jsonData.arrayValue.map {$0["idTag"].stringValue}
//                            let chargerAddress = jsonData.arrayValue.map {$0["chargerInfo"].dictionaryValue}.map {$0["chargerAddress"]!.dictionaryValue}.map {$0["street"]?.stringValue ?? ""}
//                    self.btnDate1.setTitle(bookingDate[0].string, for: .normal)
//                    self.btndate2.setTitle(bookingDate[1].string, for: .normal)
//                    self.btnDate3.setTitle(bookingDate[2].string, for: .normal)
//                    self.btnDate4.setTitle(bookingDate[3].string, for: .normal)
//                    self.lblTime.text = currentTime
//                    self.lblDate.text = todayDate
//                    self.lblEndTime.text = currentTime
//                    self.lblEndDate.text = todayDate

                           
                           
                            break
                        case .failure:
                            print(Error.self)
                           
                        }
                    }
    }
}
