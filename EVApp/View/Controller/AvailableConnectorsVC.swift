//
//  AvailableConnectorsVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 20/05/23.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON
import CoreLocation


class AvailableConnectorsVC: UIViewController{

    private var viewModel = ConnectosViewModel()
    var availableChargers:[AvailableChargers]?
    let lock = NSLock()
    var stationID : String?
    var collData : Int?
    
    @IBOutlet weak var chargerTable: UITableView!
    var reason = [[String]]()
    var totalConnector = [Int?]()
    var availableConnector = [Int?]()
    var chargerNameList = [String?]()
    var distance = [String]()
    var timingList = [String?]()
    var street = [String?]()
    var city  =  [String]()
    var avgRating  =  [Float]()
    var houseNumber = [""]
    var connectorName = [[""]]
    var amenities = [[""]]
    var price = [""]
    var connectorType = [""]
    var chargeBoxId = [[String]]()
    var available = [[Bool]]()
    var dataList = [Any]()
    var contrList = [""]
    var stationId = [""]
    var contrData = [[String]]()
    var charPrice =  [[Int]]()
    var charType = [[String]]()
    var stationData:StationList?
    var locationManager = CLLocationManager()
    var currentUserLocation: CLLocation!
    var maintenance = [Bool]()
    var parkingPrice = [[Int]]()
   // var statinData: [ChargerInfo]?
   // var connData: [ChargerStationConnectorInfo]?
    var cName = String()
    var charBoxId = String()
    var ctype = String()
    var cPrice = String()
    var sName = String()
    var sAdd = String()
    fileprivate var tableViewCellCoordinator: [Int: IndexPath] = [:]
    var priceRs = [Int]()
    let stationUrl = EndPoints().baseUrlDev + EndPoints().chargersStations
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.configuration()
//        chargerTable.reloadData()
        callChargerApi()
        self.chargerTable.reloadData()
//        callChargerApis()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        chargerTable.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        //callChargerApi()
        
        chargerTable.reloadData()
    }
    override func viewDidLayoutSubviews() {
        chargerTable.reloadData()
    }
 
    @IBAction func back(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MenuNavigationPoint") as! MenuNavigation
        self.present(nextViewController, animated:true, completion:nil)
      
    }
    
    // MARK: - API Call
    
    func callChargerApi(){
        showSpinner(onView: view)
        AvailableChargerManager.shared.chargerStationsRequest(request: "", success: { (response) in
            print(response)
            self.removeSpinner()
            self.availableChargers = response
            let stationIndex = self.getStationIDIndex()
            let availableConnectors = self.availableChargers?[stationIndex]
            let stationName = availableConnectors?.chargerInfos?[0]
            print(stationName!)
            self.getSortedByDistance()
            self.removeSpinner()
            DispatchQueue.main.async {
                self.chargerTable.reloadData()
            }
        }, fail: {
            print("Failed to fetch response")
        })
            
    }
    
    
    func callChargerApis(){
        let stateUrl = EndPoints().baseUrlDev + EndPoints().chargersStations
        let headers:HTTPHeaders = [
          
        ]
       // LoadingOverlay.shared.showOverlay(view: view)
        self.showSpinner(onView: view)
        AF.request(stateUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { [self]
                    response in
           // LoadingOverlay.shared.hideOverlayView()
           
            self.removeSpinner()
                    switch (response.result) {

                    case .success(let value):
                        print(response)
//                        availableChargers = response
                       let statusCode = response.response?.statusCode
                      print(statusCode)
                        
                let jsonData = JSON(value)
                        print(jsonData)
                        let totalConnector = jsonData.arrayValue.map {$0["totalConnectors"].intValue}
                        let availableConnector = jsonData.arrayValue.map {$0["availableConnectors"].intValue}
                        let stationId = jsonData.arrayValue.map {$0["stationId"].stringValue}
                        let stationTimings = jsonData.arrayValue.map {$0["stationTimings"].stringValue}
                        let maintenance = jsonData.arrayValue.map {$0["maintenance"].boolValue}
                        let avgRating = jsonData.arrayValue.map {$0["avgRating"].floatValue}
                        let stationNameList = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.map {$0["name"].stringValue}}
                        let nameList = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.first?["name"].stringValue}
                        let street = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["city"]?.stringValue}
                        print(street)
                        let dataList = jsonData.arrayValue
                        let contrDataInfo = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue}
                   // var contrData1 = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["connectorNo"].stringValue}}}
                       // let ab =  Array(contrData.joined())
                    let locations = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}
                        //My location
                        let myLocation = LocationManager.shared.curentLocation
                        let coordinate = myLocation?.location.coordinate
                    
                        let curLocation = CLLocation(latitude: coordinate?.latitude ?? 00.00, longitude: coordinate?.longitude ?? 00.00)
                       // let curLocation = CLLocation(latitude: trackLocations.latitude, longitude: trackLocations.longitude)
                        for location in locations
                        {
                            let latitude = location["latitude"]?.floatValue
                            let longitude = location["longitude"]?.floatValue
                            print(latitude)
                            let charLocation = CLLocation(latitude: Double(latitude ?? 00.00), longitude: Double(longitude ?? 00.00))
                            let totDistance = curLocation.distance(from: charLocation) / 1000
                            let dis  = String(format: "%.01fkm", totDistance)
                            self.distance.append(String(dis))
                            print(totDistance)
                            print(dis)
                            
                        }
                        print( self.distance)
                        for name in contrDataInfo {
                            let contrData = name.map {$0["chargerStationConnectorInfos"].arrayValue}
                            let connData =  Array(contrData.joined())
                            let conn = connData.map {$0["connectorNo"].stringValue}
                            let chargerPrice = connData.map {$0["chargerPrice"].intValue}
                            let connectorType = connData.map {$0["connectorType"].stringValue}
                            let chargeBoxId = connData.map {$0["chargeBoxId"].stringValue}
                            let available = connData.map {$0["available"].boolValue}
                            let parkingPrice = connData.map {$0["parkingPrice"].intValue}
                            let reason = connData.map {$0["reason"].stringValue}
                            
                            self.contrData.append(conn)
                            self.charPrice.append(chargerPrice)
                            self.charType.append(connectorType)
                            self.chargeBoxId.append(chargeBoxId)
                            self.available.append(available)
                            self.parkingPrice.append(parkingPrice)
                            self.reason.append(reason)
                            let addData = name.map {$0["chargerAddress"].dictionaryValue}
                            print(self.charType)
                        }
                        self.stationId = stationId
                        let houseNumber = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["houseNumber"]!.stringValue}
                      //  let price = jsonData.arrayValue.map {$0["chargerConnectorPrices"].arrayValue}[0].map {$0["price"].stringValue}
                        let connectorNo = jsonData.arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["connectorNo"].stringValue}}
                        let connectorId = jsonData.arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["connectorId"].stringValue}}
                        let location = jsonData.arrayValue.map {$0["chargerStationConnectorInfos"].arrayValue.map {$0["location"].stringValue}}

                        let amenities = jsonData.arrayValue.map {$0["chargerInfos"].arrayValue.map {$0["chargerPointAmeneties"].dictionaryValue}.map {$0["amenities"]!.stringValue}}
                        //[0].map {$0["connectorNo"].stringValue}
                        print(amenities)
                        let allStation =  Array(stationNameList.joined())
                        print(allStation)
                        self.totalConnector = totalConnector
                        self.availableConnector = availableConnector
                        self.connectorType = connectorType
                        self.connectorName = connectorNo
//                        self.chargerBoxId = chargeBoxId
//                        self.price = chargerPrice
                        self.houseNumber  = houseNumber
                        self.amenities = amenities
                        self.street  = street
                        self.city = city
                        self.chargerNameList = nameList
                        self.available = available
                        self.dataList = dataList
                        self.contrList =  contrList
                        self.avgRating = avgRating
                        self.maintenance = maintenance
                        
                        self.timingList = stationTimings
     
                        self.chargerTable.reloadData()

                        break
                    case .failure:
                        print(Error.self)
                       
                    }
                }
    }

}
extension AvailableConnectorsVC:UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource{
    //TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.chargerNameList)
//        if self.chargerNameList != nil{
//            
//        }else{
//        return 0
//        }
        return self.availableChargers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailableConnectorCell", for: indexPath) as? AvailableConnectorCell

        
        let chargersDetails:ChargerInformation? = availableChargers?[indexPath.row].chargerInfos?[0]
        cell!.lblChargerName.text! = chargersDetails?.name ?? ""
        
        let chargerConnInfo = chargersDetails?.chargerStationConnectorInfos?[0]
        
        collData = availableChargers?[indexPath.row].chargerInfos?.count
//        collData = chargersDetails?.chargerStationConnectorInfos?.count
//        contrData = chargersDetails?.chargerStationConnectorInfos
        
        let startTiming = chargerConnInfo?.startTime ?? "12:00 AM"
        let endTiming = chargerConnInfo?.endTime ?? "12:00 PM"
        
        cell!.lblTiming.text! = startTiming + "-" + endTiming
        cell!.lblAddress.text! = chargersDetails?.chargerAddress?.street ?? ""
        
        cell?.btnOpen.layer.cornerRadius = 8
        cell?.btnOpen.tag = indexPath.row
        cell?.btnOpen.isUserInteractionEnabled = false
        cell?.lblAvgRating.text = String((availableChargers?[indexPath.row].avgRating)!)
        let mantinance = availableChargers?[indexPath.row].maintenance
        if  mantinance == true{
            cell?.lblOpen.text = "Under-maintenance"
        }else{
            cell?.lblOpen.text = "OPEN"
        }
        cell?.btnOpen.addTarget(self, action: #selector(openAction(sender:)), for: .touchUpInside)
        cell?.btnCall.addTarget(self, action: #selector(callAction(sender:)), for: .touchUpInside)

        cell?.collectionView.delegate = self
        cell?.collectionView.dataSource = self
        let tag = tableViewCellCoordinator.count
        cell?.collectionView.tag = indexPath.row
        tableViewCellCoordinator[tag] = indexPath
        cell?.collectionView.reloadData()
        //print(contrData[tag])
        
        let add = chargersDetails?.chargerAddress?.street

        self.sName = chargersDetails?.name ?? ""
        self.sAdd = add ?? ""
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 430
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier:"ChargingDetailVC") as! ChargingDetailVC
        
        let chargersDetails:ChargerInformation? = availableChargers?[indexPath.row].chargerInfos?[0]
        var infos = (chargersDetails?.chargerStationConnectorInfos)
        
        nextVC.name = chargersDetails?.name ?? ""
//        nextVC.chargerConnectionInfo = infos!        
        
//        let startTiming = infos?[indexPath.row].startTime ?? "12:00 AM"
//        let endTiming = infos?[indexPath.row].endTime ?? "12:00 PM"
        
//        let chargerConnInfo = chargersDetails?.chargerStationConnectorInfos?[0]
//        let startTiming = chargerConnInfo?.startTime ?? "12:00 AM"
//        let endTiming = chargerConnInfo?.endTime ?? "12:00 PM"
        
        nextVC.connectorName = getConnectorName(chargerInformation: (chargersDetails?.chargerStationConnectorInfos)!)
        nextVC.price = getPrice(chargerInformation: (chargersDetails?.chargerStationConnectorInfos)!)
        nextVC.connectorType = getConnectorType(chargerInformation: (chargersDetails?.chargerStationConnectorInfos)!)
        nextVC.chargerBoxId = getChargerBoxID(chargerInformation: (chargersDetails?.chargerStationConnectorInfos)!)
        nextVC.available = getConnectorAvailable(chargerInformation: (chargersDetails?.chargerStationConnectorInfos)!)
        nextVC.maitinance = availableChargers?[indexPath.row].maintenance ?? false
        nextVC.stationId = availableChargers?[indexPath.row].stationId ?? ""
        nextVC.time = availableChargers?[indexPath.row].stationTimings ?? ""
        nextVC.availableCharger = "\(availableChargers?[indexPath.row].availableConnectors ?? 0)/ \(availableChargers?[indexPath.row].totalConnectors ?? 0)"
        nextVC.parkingCharges = getParkingPrice(chargerInformation: (chargersDetails?.chargerStationConnectorInfos)!)
        nextVC.reason = getReason(chargerInformation: (chargersDetails?.chargerStationConnectorInfos)!)
        nextVC.distance = getDistance(location: (availableChargers?[indexPath.row].stationChargerAddress)!)
        self.present(nextVC, animated:true, completion:nil)
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
    
    func getTime(chargerInformation:[ChargerStationConnectorInfos]) -> [String]{
        var name = [String]()
        for index in 0...(chargerInformation.count - 1){
            let dic = chargerInformation[index]
            
            let startTime = (dic.startTime ?? "5:00 AM") + " to " + (dic.endTime ?? "12:00 AM")
            
            name.append(startTime)
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

    @objc func openAction(sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier:"ChargingDetailVC") as! ChargingDetailVC
        nextVC.name =  self.chargerNameList[sender.tag] ?? ""
        nextVC.connectorName = contrData[sender.tag]
        nextVC.price = charPrice[sender.tag]
        nextVC.connectorType = charType[sender.tag]
        nextVC.chargerBoxId = chargeBoxId[sender.tag]
        nextVC.available = available[sender.tag]
        nextVC.distance  = self.distance[sender.tag]
        nextVC.maitinance = self.maintenance[sender.tag]
        nextVC.stationId = stationId[sender.tag]
        //self.navigationController?.pushViewController(nextVC, animated: false)
        chargerTable.reloadData()
        self.present(nextVC, animated:true, completion:nil)
    }
    
    @objc func callAction(sender: UIButton) {
        if let url = URL(string: "tel://\("8383070677")"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    // MARK: - Distance Soting -
    
    func getSortedByDistance(){
        for index in 0...((availableChargers?.count ?? 0) - 1) {
            let distance = getDistance(location: (availableChargers?[index].stationChargerAddress)!)
            availableChargers?[index].message = distance//.chargerInfos?[0].distance = distance
        }
        //      let sorted =  availableChargers?.sorted(by: { $0.message ?? "" < $1.message ?? ""})
        //        for index in 0...((availableChargers?.count ?? 0) - 1){
        //            print("sorted distance --- \(availableChargers?[index].message ?? "failed")")
        //        }
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
    
    func getStationIDIndex() -> Int{
        for index in 0...((availableChargers?.count ?? 0) - 1) {
            let stationIndex = availableChargers?[index]
            
            if stationIndex?.stationId == stationID {
                return index
            }
        }
        return 0
    }
}
extension AvailableConnectorsVC {
 
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as? AvailableConnectorCell
        cell?.collectionView.reloadData()
        cell?.collectionView.contentOffset = .zero
        
    }
}

extension AvailableConnectorsVC{
    //CollectonView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 1
       }
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print(contrData)
//    var text = ""
//    if let indexPathOfCellInTableView = tableViewCellCoordinator[collectionView.tag] {
//                text = "\(indexPathOfCellInTableView)"
//            }
//   let list = contrData[collectionView.tag]
   // print(list)
    //let allStation =  Array(a.joined())
   
   // return contrData[collectionView.tag].count
    return collData ?? 0
   // return 5

      }

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionConCell", for: indexPath) as? CollectionConCell
    
    let count = availableChargers?[collectionView.tag].chargerInfos?.count
    let chargersDetails:ChargerInformation? = availableChargers?[collectionView.tag].chargerInfos?[indexPath.row]
    let chargerConnInfo = chargersDetails?.chargerStationConnectorInfos?[0]
    
    cell?.btnStart.tag = (collectionView.tag * 1000) + indexPath.row
    self.cName = chargerConnInfo?.connectorId ?? ""
    self.charBoxId = chargerConnInfo?.chargeBoxId ?? ""
    self.ctype = chargerConnInfo?.connectorType ?? ""
//    self.cPrice = String(chargerConnInfo?.chargerPrice) ?? ""
    
//    self.cPrice = String(self.charPrice[collectionView.tag][indexPath.row])
    
    
        cell?.bcView.layer.cornerRadius = 5
        cell?.bcView.layer.borderColor   = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        cell?.bcView.layer.borderWidth = 1
        cell?.btnStart.layer.cornerRadius = 5

    if self.ctype == "DC" {
        cell?.imgConn.image = UIImage(named: "dc")
    }else{
        cell?.imgConn.image = UIImage(named: "ac")
    }
    
    let priceRs = chargerConnInfo?.chargerPrice
//    self.priceRs = priceRs
//    cell?.lblPrice.text = "₹" + String(Float(chargerConnInfo?.chargerPrice ?? 0)) + "/Unit"

    
    let intPrice = Float((chargerConnInfo?.chargerPrice)!)
    cell?.lblPrice.text = "₹" + String(format: "%.2f", intPrice) + "/Unit"
    
    cell?.lblConnector.text = chargerConnInfo?.chargeBoxId ?? "" + ":" + (chargerConnInfo?.connectorNo ?? "")
    cell?.lblType.text = chargerConnInfo?.connectorType
    
    let reason = chargerConnInfo?.reason //available.first?[indexPath.row]
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
    }
    cell?.btnStart.accessibilityIdentifier = String(collectionView.tag)
    cell?.btnStart.tag = indexPath.row
    cell?.btnStart.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
    return cell!

      }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("selected collectionViewCell with indexPath: \(indexPath) in tableViewCell with indexPath: \(tableViewCellCoordinator[collectionView.tag]!)")
        }
    
    @objc func connected(sender: UIButton){
        
        let intIndex = Int(sender.accessibilityIdentifier!)!
        let chargersDetails:ChargerInformation? = availableChargers?[intIndex].chargerInfos?[0]
        let chargerStationConnectorInfos = chargersDetails?.chargerStationConnectorInfos?[sender.tag]
        print( self.cPrice)
        
        let reason = chargerStationConnectorInfos?.reason
        if reason == "Available"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ChargingStationVC") as! ChargingStationVC
            
            nextViewController.stationId = availableChargers?[intIndex].stationId ?? ""
//            nextViewController.stationId = stationId[sender.tag]
            nextViewController.parkingPrice = String(chargerStationConnectorInfos?.parkingPrice ?? 0)
            nextViewController.stationName = chargersDetails?.name ?? ""
            nextViewController.stationAddress = chargersDetails?.chargerAddress?.street ?? ""
            nextViewController.connName = chargerStationConnectorInfos?.connectorNo ?? ""
            nextViewController.chargerBoxId = chargerStationConnectorInfos?.chargeBoxId ?? ""
            nextViewController.type = chargerStationConnectorInfos?.connectorType ?? ""
            nextViewController.price = String(chargerStationConnectorInfos?.chargerPrice ?? 0)
            self.present(nextViewController, animated:true, completion:nil)
            
            //        nextViewController.parkingPrice = String(self.parkingPrice[section][row])
            //        nextViewController.stationName = self.sName
            //        nextViewController.stationAddress = self.street[section] ?? ""
            //        nextViewController.connName = self.cName
            //        nextViewController.chargerBoxId = self.charBoxId
            //        nextViewController.type = self.ctype
            //        nextViewController.price = self.cPrice
            
        }else if reason == "Charger in use"{
            showToast(title: "Yahhvi", message: "Charger in use")
        }else if reason == "UnderMaintenance"{
            showToast(title: "Yahhvi", message: "Under Maintenance")
        }
        else{
            showToast(title: "Yahhvi", message: "Power Loss")
            //                cell?.btnStart.isUserInteractionEnabled = false
        }
    }
}
extension AvailableConnectorsVC{
    func configuration() {
       // self.itemsTableView.register(UINib(nibName: "ItemsTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemsTableViewCell")
        eventObserver()
        viewModel.fetchConnectors()
    }
    func eventObserver(){
        viewModel.eventHandler = { [weak self] event in
            guard let self else { return }

            switch event {
            case .loading:
                /// Indicator show
                print("Product loading....")
            case .stopLoading:
                // Indicator hide kardo
                print("Stop loading...")
            case .dataLoaded:
                print("Data loaded...")
                DispatchQueue.main.async {
                    self.chargerTable.reloadData()
                }
            case .error(let error):
                print(error)
            //case .newProductAdded(let newProduct):
              //  print(newProduct)
            }
        }
    }
    
}
