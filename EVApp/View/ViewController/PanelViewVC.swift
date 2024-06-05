//
//  PanelViewVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit
//import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON

class PanelViewVC: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var lbNearbyCharger: UILabel!
    @IBOutlet weak var lbStationName: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    var address = [""]
    var chargerNameList = [[""]]
    var  street  =  [""]
    var houseNumber = [""]
    var connectorName = [[""]]
    var amenities = [[""]]
    var price = [""]
    var connectorType = [""]
    var chargerBoxId = [""]
    var available = [[Bool]]()
    var dataList = [Any]()
    var contrList = [""]
    var contrData = [[String]]()
    var charPrice =  [[Int]]()
    var charType = [[String]]()
    var chargeBoxId = [[String]]()
    var chargePrice = [[Int]]()
    var cName = String()
    var charBoxId = String()
    var ctype = String()
    var cPrice = Int()
    var availableChargers:[AvailableChargers]?
    var isShowStations: Bool = false
    var stationID : String?
    let lock = NSLock()
    var reason : String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.topView.layer.cornerRadius = 40
        topView.clipsToBounds = true
        topView.layer.cornerRadius = 30
        topView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        if isShowStations{
            lbNearbyCharger.isHidden = false
        }else {
            lbNearbyCharger.isHidden = true
        }
        //callChargerApi()
        self.showSpinner(onView: view)
        
        AvailableChargersRepo().getAvailableChargingStations{ res in
            switch res{
            case .success(let chargers):
                self.removeSpinner()
                self.availableChargers = chargers
                let stationIndex = self.getStationIDIndex()
                let availableConnectors = self.availableChargers?[stationIndex]
                let stationName = availableConnectors?.chargerInfos?[0]
                if self.isShowStations{
                    self.getSortedByDistance()
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                    self.lbStationName.text = stationName?.name ?? ""
                    self.lblCount.text = "\(availableConnectors?.availableConnectors ?? 0)/\(availableConnectors?.totalConnectors ?? 0)"
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSortedByDistance(){
        for index in 0...((availableChargers?.count ?? 0) - 1) {
            let distance = getDistance(location: (availableChargers?[index].stationChargerAddress)!)
            availableChargers?[index].message = distance//.chargerInfos?[0].distance = distance
        }
        DispatchQueue.global(qos: .userInitiated).async {
            self.printSortedDistance()
        }
        
    }
    
    func printSortedDistance(){
        lock.lock()
        for i in stride(from: (availableChargers?.count ?? 1)-1, to: 0, by: -1) {
            for j in 1...i {
                if Float(availableChargers?[j-1].message ?? "0") ?? 0 > Float(availableChargers?[j].message ?? "0") ?? 0 {
                    let tmp = availableChargers?[j-1]
                    let currentValue = availableChargers?[j]
                    availableChargers?[j-1] = currentValue! //availableChargers![j]
                    availableChargers?[j] = tmp!
                }
            }
        }
        lock.unlock()
        for index in 0...((availableChargers?.count ?? 0) - 1){
            print("sorted distance --- \(availableChargers?[index].message ?? "failed")")
        }
    }
    
    func getStationIDIndex() -> Int{
        for index in 0...((availableChargers?.count ?? 0) - 1) {
            let stationIndex = availableChargers?[index]
            if stationIndex?.stationId == stationID {
                return index
            }
        }
        return 0
    }
    
    
    // MARK: - Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowStations{
            
            return  availableChargers?.count ?? 0
        }
        let chargers = availableChargers?[getStationIDIndex()]
        return  chargers?.chargerInfos?[0].chargerStationConnectorInfos?.count ?? 0 //charType.first?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowStations{
            
            self.tableView.allowsSelection = true
            let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell", for: indexPath) as? StationCell
            cell?.selectionStyle = .none
            let chargersDetails:ChargerInformation? = availableChargers?[indexPath.row].chargerInfos?[0]
            cell?.lbStationName.text = chargersDetails?.name ?? ""
            cell?.lbAddress.text = chargersDetails?.chargerAddress?.street ?? ""
            cell?.distance.text = "Distance: \(availableChargers?[indexPath.row].message ?? "") km"
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PanelTableViewCell", for: indexPath) as? PanelTableViewCell
            // filter data from charger
            cell?.btnStart.layer.cornerRadius = 6
            cell?.btnStart.layer.masksToBounds = true
            let chargersDetails:ChargerInformation? = availableChargers?[getStationIDIndex()].chargerInfos?[0]
            let stationDetails = chargersDetails?.chargerStationConnectorInfos?[indexPath.row]
            cell?.btnStart.tag = indexPath.row
            //cell?.btnStart.tag = (indexPath.section * 1000) + indexPath.row
            self.cName = contrData.first?[indexPath.row] ?? ""
            self.charBoxId = String(chargeBoxId.first?[indexPath.row] ?? "")
            self.ctype = charType.first?[indexPath.row] ?? ""
            self.cPrice = chargePrice.first?[indexPath.row] ?? 0
            // let availability = self.available.first?[indexPath.row]
            reason = stationDetails?.reason //available.first?[indexPath.row]
            if reason == "Available"{
                cell?.btnStart.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            }else if reason == "Charger in use"{
                cell?.btnStart.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            }else if reason == "UnderMaintenance"{
                cell?.btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            }
            else{
                cell?.btnStart.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                cell?.isUserInteractionEnabled = true
                //                cell?.btnStart.isUserInteractionEnabled = false
            }
            if stationDetails?.connectorType == "DC"{
                cell?.imgType.image = UIImage(named: "dc")
            }else {
                cell?.imgType.image = UIImage(named: "ac")
            }
            cell?.lblName.text! =  chargersDetails?.chargeBoxId ?? "" + "-" + (stationDetails?.connectorId ?? "") //(chargeBoxId.first?[indexPath.row] ?? "") + "-" + (contrData.first?[indexPath.row] ?? "")
            cell?.lblDdetail.text! = (stationDetails?.connectorType ?? "") + "kWh" //charType.first?[indexPath.row] ?? ""
            cell?.btnStart.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isShowStations{
            return 110
        }
        return 85
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isShowStations{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier:"ChargingDetailVC") as! ChargingDetailVC
            let stationDetails:ChargerInformation? = availableChargers?[indexPath.row].chargerInfos?[0]
            nextVC.name = stationDetails?.name ?? ""
            nextVC.connectorName = getConnectorName(chargerInformation: (stationDetails?.chargerStationConnectorInfos)!)
            nextVC.price = getPrice(chargerInformation: (stationDetails?.chargerStationConnectorInfos)!)
            nextVC.connectorType = getConnectorType(chargerInformation: (stationDetails?.chargerStationConnectorInfos)!)
            nextVC.chargerBoxId = getChargerBoxID(chargerInformation: (stationDetails?.chargerStationConnectorInfos)!)
            nextVC.available = getConnectorAvailable(chargerInformation: (stationDetails?.chargerStationConnectorInfos)!)
            nextVC.maitinance = availableChargers?[indexPath.row].maintenance ?? false
            nextVC.stationId = availableChargers?[indexPath.row].stationId ?? ""
            nextVC.availableCharger = "\(availableChargers?[indexPath.row].availableConnectors ?? 0)/ \(availableChargers?[indexPath.row].totalConnectors ?? 0)"
            nextVC.parkingCharges = getParkingPrice(chargerInformation: (stationDetails?.chargerStationConnectorInfos)!)
            nextVC.reason = getReason(chargerInformation: (stationDetails?.chargerStationConnectorInfos)!)
            nextVC.distance = getDistance(location: (availableChargers?[indexPath.row].stationChargerAddress)!)
            self.present(nextVC, animated:true, completion:nil)
        }
    }
    
    // MARK: - Custom Methods
    func getDistance(location: StationChargerAddress) -> String{
        //My location
        let myLocation = LocationManager.shared.curentLocation
        let coordinate = myLocation?.location.coordinate
        
        let curLocation = CLLocation(latitude: coordinate?.latitude ?? 00.00, longitude: coordinate?.longitude ?? 00.00)
        
        let latitude = Float(location.latitude ?? "")
        let longitude = Float(location.longitude ?? "")
        let charLocation = CLLocation(latitude: Double(latitude ?? 00.00), longitude: Double(longitude ?? 00.00))
        let totDistance = curLocation.distance(from: charLocation)
        let distance  = String(format: "%.01f", Float(totDistance)/1000)
        return distance
    }
    func getChargerBoxID(chargerInformation:[ChargerStationConnectorInfos]) -> [String]{
        var name = [String]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            name.append(dic.chargeBoxId ?? "")
        }
        return name
    }
    func getConnectorName(chargerInformation:[ChargerStationConnectorInfos]) -> [String]{
        var name = [String]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            name.append(dic.connectorNo ?? "")
        }
        return name
    }
    func getConnectorType(chargerInformation:[ChargerStationConnectorInfos]) -> [String]{
        var name = [String]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            name.append(dic.connectorType ?? "")
        }
        return name
    }
    func getReason(chargerInformation:[ChargerStationConnectorInfos]) -> [String]{
        var name = [String]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            name.append(dic.reason ?? "")
        }
        return name
    }
    func getConnectorAvailable(chargerInformation:[ChargerStationConnectorInfos]) -> [Bool]{
        var name = [Bool]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            name.append(dic.available)
        }
        return name
    }
    func getPrice(chargerInformation:[ChargerStationConnectorInfos]) -> [Int]{
        var name = [Int]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            name.append(dic.chargerPrice ?? 0)
        }
        return name
    }
    
    func getParkingPrice(chargerInformation:[ChargerStationConnectorInfos]) -> [Int]{
        var name = [Int]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            name.append(dic.parkingPrice ?? 0)
        }
        return name
    }
    
    @objc func connected(sender: UIButton){
        
        if reason == "Available"{
            let row = sender.tag%1000
            let section = getStationIDIndex()
            let stationDetails:ChargerInformation? = availableChargers?[section].chargerInfos?[0]
            let chargerDetails = stationDetails?.chargerStationConnectorInfos?[row]
            let buttonTag = sender.tag
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingStationVC") as! ChargingStationVC
            nextViewController.stationName = stationDetails?.name ?? ""
            nextViewController.stationAddress = stationDetails?.chargerAddress?.city ?? ""
            nextViewController.connName = chargerDetails?.connectorNo ?? ""
            nextViewController.chargerBoxId = chargerDetails?.chargeBoxId ?? ""
            nextViewController.type = chargerDetails?.connectorType ?? ""
            nextViewController.price = String(chargerDetails?.chargerPrice ?? 0)//String(cPrice)
            nextViewController.parkingPrice = String(chargerDetails?.parkingPrice ?? 0)
            nextViewController.stationId = String(chargerDetails?.stationId ?? "")
            self.present(nextViewController, animated:true, completion:nil)
        }else if reason == "Charger in use"{
            showToast(title: "Yahhvi", message: "Charger in use")
        }else if reason == "UnderMaintenance"{
            showToast(title: "Yahhvi", message: "Under Maintenance")
        }
        else{
            showAlert(title: "Yahhvi", message: "Power Loss")
        }
    }
    
    /* ************************** Unused Code ********************************
     func callChargerApi(){
     let stateUrl = EndPoints().baseUrlDev + EndPoints().chargersStations
     let headers:HTTPHeaders = [
     
     ]
     self.showSpinner(onView: view)
     
     AF.request(stateUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { [self]
     response in
     self.removeSpinner()
     
     switch (response.result) {
     
     case .success(let value):
     print(response)
     
     let statusCode = response.response?.statusCode
     print(statusCode)
     
     let jsonData = JSON(value)
     print(jsonData)
     let stationId = jsonData.arrayValue.map {$0["stationId"].stringValue}
     let stationTimings = jsonData.arrayValue.map {$0["stationTimings"].stringValue}
     let stationNameList = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.map {$0["name"].stringValue}}
     let nameList = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.first?["name"].stringValue}
     let street = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["street"]?.stringValue}
     print(street)
     let dataList = jsonData.arrayValue
     let contrData = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue}
     // var contrData1 = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["connectorNo"].stringValue}}}
     // let ab =  Array(contrData.joined())
     
     for name in contrData{
     let contrData = name.map {$0["chargerStationConnectorInfos"].arrayValue}
     let connData =  Array(contrData.joined())
     let conn = connData.map {$0["connectorNo"].stringValue}
     let chargerPrice = connData.map {$0["chargerPrice"].intValue}
     let connectorType = connData.map {$0["connectorType"].stringValue}
     let chargeBoxId = connData.map {$0["chargeBoxId"].stringValue}
     let available = connData.map {$0["available"].boolValue}
     self.contrData.append(conn)
     self.charPrice.append(chargerPrice)
     // self.charType.append(contentsOf: connectorType)
     self.available.append(available)
     self.chargeBoxId.append(chargeBoxId)
     self.charType.append(connectorType)
     self.chargePrice.append(chargerPrice)
     let addData = name.map {$0["chargerAddress"].dictionaryValue}
     print(addData)
     print( self.contrData)
     }
     let houseNumber = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["houseNumber"]!.stringValue}
     let price = jsonData.arrayValue.map {$0["chargerConnectorPrices"].arrayValue}[0].map {$0["price"].stringValue}
     let connectorNo = jsonData.arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["connectorNo"].stringValue}}
     let connectorId = jsonData.arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["connectorId"].stringValue}}
     let location = jsonData.arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["location"].stringValue}}
     
     let amenities = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.map {$0["chargerPointAmeneties"].dictionaryValue}.map {$0["amenities"]!.stringValue}}
     print(amenities)
     
     let allStation =  Array(stationNameList.joined())
     print(stationId)
     
     self.tableView.reloadData()
     
     break
     case .failure:
     print(Error.self)
     
     }
     }
     }
     */
}


