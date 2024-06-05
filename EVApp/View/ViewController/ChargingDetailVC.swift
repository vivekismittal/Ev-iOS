//
//  ChargingDetailVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 24/05/23.
//

import UIKit

class ChargingDetailVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var lblAmeneties: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblBooking: NSLayoutConstraint!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalAvailableCharger: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var name = ""
    var address = ""
    var time : String?
    var reason = [String]()
    var connectorName = [String]()
    var chargerPointAmeneties = ""
    var price = [0]
    var connectorType = [String]()
    var chargerBoxId = [String]()
    var available = [Bool]()
    var fromPanel = false
    var distance = String()
    var cName = String()
    var charBoxId = String()
    var ctype = String()
    var cPrice = String()
    var rating = String()
    var parkingPrice = String()
    var maitinance = Bool()
    var stationId =  String()
    var availableCharger = String()
    var parkingCharges = [0]
    
//    var chargerConnectionInfo = [ChargerStationConnectorInfos]()
//    var index : Int?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblDistance: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblName.text = name
        self.lblAddress.text = address
        let amenities = chargerPointAmeneties.map { String($0) }
        let amtString = amenities.joined(separator: ",")
        print(chargerPointAmeneties)
        self.lblAmeneties.text = chargerPointAmeneties
        self.lblDistance.text = distance + " Km"
//        self.lblRating.text = rating
        lblTotalAvailableCharger.text = availableCharger
        lblTime.text = time
        if maitinance == true{
            self.showAlert(title: "Alert!", message: "This charge station is under maintenance, we will inform you once the maintenance is over. The inconvenience caused is deeply regretted.")
        }
        
    }
    @IBAction func back(_ sender: Any) {
       // self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: true)
    }
    @IBAction func reviewAction(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "StationReviewVC") as! StationReviewVC
       nextViewController.stationid = stationId
        self.present(nextViewController, animated:true, completion:nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connectorName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChargingTableViewCell", for: indexPath) as? ChargingTableViewCell
        self.cName = connectorName[indexPath.row]
        self.charBoxId = chargerBoxId[indexPath.row]
        self.ctype = connectorType[indexPath.row]
        self.cPrice = String(price[indexPath.row])
        self.parkingPrice = String(parkingCharges[indexPath.row])
        cell?.btnStart.tag = indexPath.row
        cell?.btnBooking.tag = indexPath.row
        
        let reason = reason[indexPath.row]//chargerConnInfo?.reason //available.first?[indexPath.row]
        cell?.btnStart.tag = indexPath.row
        if reason == "Available"{
            cell?.btnStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell?.view2.backgroundColor  = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell?.btnStart.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)

        }else if reason == "Charger in use"{
            cell?.btnStart.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            cell?.view2.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            cell?.btnStart.addTarget(self, action: #selector(maintinance(sender:)), for: .touchUpInside)
        }else if reason == "UnderMaintenance"{
            cell?.btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.view2.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.btnStart.addTarget(self, action: #selector(maintinance(sender:)), for: .touchUpInside)
        }
        else{
            cell?.btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.view2.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.bcView.layer.borderColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            cell?.isUserInteractionEnabled = true
            cell?.btnStart.addTarget(self, action: #selector(maintinance(sender:)), for: .touchUpInside)
        }
        if connectorType[indexPath.row] == "DC" {
            cell?.imgCharger.image = UIImage(named: "dc")
        }else{
            cell?.imgCharger.image = UIImage(named: "ac")
        }
        
      //  let chrgBoxId = chargerBoxId[indexPath.row]
        cell?.lblName.text! =  chargerBoxId[indexPath.row] + "-" + connectorName[indexPath.row]
        cell?.lblDc.text! =  connectorType[indexPath.row]
        
        let intPrice = Float((price[indexPath.row]))
        cell?.lblPrice.text = "₹" + String(format: "%.2f", intPrice) + "/Unit"
//        cell?.lblPrice.text! =  "₹" + String(Float(price[indexPath.row])) + "/Unit"
     //   cell?.lblCapacity.text! = "40kWh"
        cell?.lblCoName.text! = connectorType[indexPath.row] + " kWh"
        cell?.btnStart.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell?.btnBooking.addTarget(self, action: #selector(apointment(sender:)), for: .touchUpInside)

        
       // UserDefaults.standard.set(chrgBoxId, forKey: "chrgBoxId")
        return cell!
    }
    @objc func connected(sender: UIButton){
        let reason = reason[sender.tag]
//        if reason == "Available"{
            let buttonTag = sender.tag
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingStationVC") as! ChargingStationVC
            nextViewController.stationName = name
            nextViewController.stationAddress = address
            nextViewController.connName = cName
            nextViewController.chargerBoxId = charBoxId
            nextViewController.type = ctype
            nextViewController.price = cPrice
            nextViewController.parkingPrice = parkingPrice
            self.present(nextViewController, animated:true, completion:nil)
//        }
    }
    @objc func maintinance(sender: UIButton){
        if !available[sender.tag] {
            let message = reason[sender.tag]
            self.showToast(title: "", message: message)
        }else{
            self.showToast(title: "", message: "Under maintenance")
        }
        
    }
    @objc func apointment(sender: UIButton){
        let buttonTag = sender.tag
        let connector = connectorName[buttonTag]
        let charBoxid = chargerBoxId[buttonTag]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BookApointmentVC") as! BookApointmentVC
//        nextViewController.stationName = name
//        nextViewController.stationAddress = address
        nextViewController.connName = connector
        nextViewController.chargeBoxId = charBoxid
//        nextViewController.type = ctype
//        nextViewController.price = cPrice
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      print("Seleted")
    }
}
