//
//  DashboardVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//

import UIKit
import SideMenuSwift
import FloatingPanel
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON


class DashboardVC: UIViewController, FloatingPanelControllerDelegate, GMSMapViewDelegate{
    
//    @IBOutlet weak var btnSignup: UIButton!
    // @IBOutlet weak var guestView: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnStation: UIButton!
    var trackLocations = CLLocationCoordinate2D()
    var updatedCo = [String:Any]()
    var address = ""
    var longitude = [""]
    var latitude = [""]
    var locationDict = [[String:Any]]()
    var guest = false
    var stationId = [""]
    var distance = [String]()
    
    var staionLat = 00.00
    var latTemp = [Float?]()
    var isSheetAppear = false
//    var availableChargers = Any()
    
    @objc func methodOfReceivedNotification(notification: Notification){
        let nextViewController = WelcomeVC.instantiateUsingStoryboard()
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
     static func instantiateUsingStoryboard() -> Self {
        let dashboardVC = ViewControllerFactory<DashboardVC>.viewController(for: .HomeDashboard)
        return dashboardVC as! Self
    }
    
    // MARK: - LifeCycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        callChargerApi()
        
        self.mapView.delegate = self
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.setNeedsLayout()
        self.mapView.layoutIfNeeded()
        btnStation.layer.cornerRadius = 30

        if let currentLocation = LocationManager.shared.curentLocation{
            let coordinate = currentLocation.location.coordinate
        }
        self.checkUpdateVersion(viewController: self)
    }

    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserApi()
        
        self.mapView.isMyLocationEnabled = true
        LocationManager.shared.startLocationUpdater{() -> ()? in
            self.showLocation()
        }
    }
    
    
    
    // MARK: - Button Action
    @IBAction func menuClicked(_ sender: Any) {
        //        let app = UIApplication.shared.delegate as! AppDelegate
        
        if isSheetAppear{
            self.dismiss(animated: false)
        }
        
        isSheetAppear = false
        sideMenuController?.revealMenu()
    }
    
    @IBAction func openScreen(_ sender: Any) {
        openBottomPanel()
    }
    
    func openBottomPanel(stationID: String? = nil){
        let panelVC = PanelViewVC.instantiateUsingStoryboard()
        panelVC.stationID = stationID

        self.isSheetAppear = true
        if #available(iOS 15.0, *) {
            if let sheet = panelVC.sheetPresentationController{
                sheet.detents = [.medium() , .large()] // Sheet style
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                // Inside Scrolling
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24
                sheet.largestUndimmedDetentIdentifier = .medium
            }
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.present (panelVC, animated: true)
    }
    
    
    func showLocation(){
        if let currentLocation = LocationManager.shared.curentLocation{
            let coordinate = currentLocation.location.coordinate
            self.mapView.camera = .init(latitude:coordinate.latitude,longitude: coordinate.longitude, zoom: 17.0)
            self.trackLocations = coordinate
            UserAppStorage.trackLocationsLat = trackLocations.latitude
            UserAppStorage.trackLocationsLong = trackLocations.longitude

            self.mapView.isMyLocationEnabled = true
            
            
        }
    }
}


extension DashboardVC{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("marker tapped:", marker)
        print("marker tapped:", marker.position.latitude)
        staionLat =  marker.position.latitude
        guard let stationid = getStationID(coordinate: marker.position) else {
            return true
        }
        openBottomPanel(stationID: getStationID(coordinate: marker.position))
        return true
    }
    
    func getStationID(coordinate:CLLocationCoordinate2D) -> String?{
        for i in 0...locationDict.count - 1{
            let dic = locationDict[i]
            
            var latitude: String? = String(describing: (dic["latitude"]))
            latitude = latitude?.replacingOccurrences(of: "Optional(", with: "")
            latitude = latitude?.replacingOccurrences(of: ")", with: "")
            
            var longitude: String? = String(describing: dic["longitude"])
            longitude = longitude?.replacingOccurrences(of: "Optional(", with: "")
            longitude = longitude?.replacingOccurrences(of: ")", with: "")
            if let lat = latitude, let lon = longitude{
                let floatLatitude = Float(lat)
                let lati = "\(floatLatitude ?? 0.0)"
                let floatLongitude = Float(lon)
                let longi = "\(floatLongitude ?? 0.0)"
                if lati == String(Float(coordinate.latitude)) && longi == String(Float(coordinate.longitude)) {
                    let stationid = stationId[i]
                    return stationid
                }
            }
        }
        return nil
    }
    
    
    
    
    // MARK: - API Call
    
    func getUserApi(){
        let loginUrl  = EndPoints.shared.baseUrlDev +  EndPoints.shared.getUserByPhone
        
        // self.showSpinner(onView: view)
        
        let userMobile = UserAppStorage.userMobile
        let parameters = [
            "mobileNumber": userMobile
        ] as? [String:AnyObject]
        print(parameters)
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            //  self.removeSpinner()
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
//                let statusCode = response.response?.statusCode
//                print(statusCode!)
                
                let jsonData = JSON(value)
//                print(jsonData)
                
//                let status = jsonData["status"].string
//                let message = jsonData["message"].string
                let firstName = jsonData["firstName"].string
                let eMail = jsonData["eMail"].string
//                let sex = jsonData["sex"].string
//                let vehicleModel = jsonData["vehicleModel"].string
//                let phone = jsonData["phone"].string
//                let password = jsonData["password"].string
                let lastName = jsonData["lastName"].string
                let userPk = jsonData["userPk"].intValue
//                let vehicleRegistrationNumber = jsonData["vehicleRegistrationNumber"].string
                
                let fullName = (firstName ?? "")  + (lastName ?? "")
                //  self.showToast(title: "", message: message ?? "")
                
                UserAppStorage.userFullName = fullName
                UserAppStorage.email = eMail ?? ""
                UserAppStorage.userPk = userPk
                //  self.txtGst.text = vehicleModel
                print(userPk)
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    func callChargerApi(){
        let stateUrl = EndPoints.shared.baseUrlDev + EndPoints.shared.chargersStations
        let headers:HTTPHeaders = [
            
        ]
        self.showSpinner(onView: view)
        
        AF.request(stateUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).responseJSON { [self]
            response in
            
            self.removeSpinner()
//            availableChargers = response.result
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let statusCode = response.response?.statusCode
                
                let jsonData = JSON(value)
                print(jsonData)
                
                let stationId = jsonData.arrayValue.map {$0["stationId"].stringValue}
                _ = jsonData.arrayValue.map {$0["name"].stringValue}
                let street = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["street"]!.stringValue}
                let latitude = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["latitude"]!.stringValue}
                let longitude = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}.map {$0["longitude"]!.stringValue}
                let locations = jsonData.arrayValue.map {$0["stationChargerAddress"].dictionaryValue}
                
                print(locations)
                self.locationDict = locations
                self.latitude =  latitude
                self.longitude = longitude
                self.stationId = stationId
                print(latitude)
                print(longitude)
                trackLocations.latitude = UserAppStorage.trackLocationsLat ?? 0
                trackLocations.longitude = UserAppStorage.trackLocationsLong ?? 0
                //My location
                let lat = trackLocations.latitude
                let curLocation = CLLocation(latitude: trackLocations.latitude, longitude: trackLocations.longitude)
                print(lat)
                var bounds = GMSCoordinateBounds()
                for location in locations
                {
                    let latitude = location["latitude"]?.floatValue
                    let longitude = location["longitude"]?.floatValue
                    self.latTemp.append(latitude)
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude ?? 00.00),longitude: CLLocationDegrees(longitude ?? 00.00))
                    // marker.map = self.mapView
                    bounds = bounds.includingCoordinate(marker.position)
                    marker.icon = #imageLiteral(resourceName: "yahhvi")
                    marker.map = self.mapView
                    
                    // distance calculation
                    let charLocation = CLLocation(latitude: Double(latitude ?? 00.00), longitude: Double(longitude ?? 00.00))
                    //Measuring my distance to my buddy's (in km)
                    let totDistance = curLocation.distance(from: charLocation) / 1000
                    self.distance.append(String(totDistance))
                    //Display the result in km
                    print(String(format: "The distance to charger is %.01fkm", distance))
                    
                }

                
//                let camera = GMSCameraPosition.camera(withLatitude: trackLocations.latitude, longitude: trackLocations.longitude, zoom: 17.0)
//                self.mapView.camera = camera
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
}


/*
 eMail: String
 phone: String
 lastName: String
 sex: String
 referralStatus: Bool
 corporateUser: Bool
 
 
 {
   "eMail" : null,
   "phone" : "8273928231",
   "manufacturer" : null,
   "vehicleType" : null,
   "amount" : 0,
   "vehicleRegistrationNumber" : null,
   "referralPoints" : null,
   "lastName" : null,
   "sex" : "MALE",
   "referralStatus" : false,
   "address" : {
     "shortForm" : null,
     "countryAlpha2OrNull" : null,
     "empty" : true,
     "websiteName" : null,
     "street" : null,
     "billingAddress" : null,
     "chargerType" : null,
     "addressPk" : null,
     "gstNumber" : null,
     "city" : null,
     "country" : null,
     "zipCode" : null,
     "houseNumber" : null,
     "state" : null,
     "operatingMode" : null,
     "phoneNumber" : null,
     "stateCode" : null
   },
   "corporateUser" : false,
   "note" : null,
   "referralLink" : "https:\/\/play.google.com\/store\/apps\/details?id=com.yahhvi.evcharing&ref=G5DYVN6H4A",
   "birthDay" : null,
   "message" : "User Details Found",
   "vinNumber" : null,
   "referralCode" : "G5DYVN6H4A",
   "userPk" : 1159,
   "password" : null,
   "status" : "True",
   "photo" : null,
   "countryId" : null,
   "guestUser" : true,
   "firstName" : "Guest"
 }
 */
