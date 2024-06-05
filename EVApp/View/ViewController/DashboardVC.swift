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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    // MARK: - LifeCycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
            NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
//            self.btnSignup.layer.cornerRadius  = 12
            callChargerApi()
            getUserApi()
            self.mapView.delegate = self
            self.mapView.translatesAutoresizingMaskIntoConstraints = false
            self.mapView.setNeedsLayout()
            self.mapView.layoutIfNeeded()
        
            if let currentLocation = LocationManager.shared.curentLocation{
                let coordinate = currentLocation.location.coordinate
                print(coordinate.latitude)
                print(coordinate.longitude)
            }
            let deviceID = UIDevice.current.identifierForVendor!.uuidString
            print("Device UUID\(deviceID)")
            let app = UIApplication.shared.delegate as! AppDelegate
            app.checkUpdateVersion(viewController: self)
    }

    override func viewDidLayoutSubviews() {
        btnStation.layer.cornerRadius = 30
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserApi()
        
        self.mapView.isMyLocationEnabled = true
        LocationManager.shared.startLocationUpdater{() -> ()? in
            self.showLocation()
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        LocationManager.shared.curentLocation = nil
//    }
    
    
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
        if let vc
            =
            self.storyboard?.instantiateViewController(withIdentifier:
                                                        "PanelViewVC") as? PanelViewVC{
            //   vc.stationIndex = index
            vc.isShowStations = true
            self.isSheetAppear = true
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController{
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
            self.navigationController?.present (vc, animated: true)
        }
    }
//    @IBAction func signup(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
//        self.present(nextViewController, animated:true, completion:nil)
//    }
    
    
    func showLocation(){
        if let currentLocation = LocationManager.shared.curentLocation{
            let coordinate = currentLocation.location.coordinate
            // getAddrFrmLtLng(latitude: coordinate.latitude, longitude: coordinate.longitude)
            //  let currentAdd = self.add
            //NotificationCenter.default.post(name: Notification.Name("currentAdd"), object: currentAdd)
            
            self.mapView.camera = .init(latitude:coordinate.latitude,longitude: coordinate.longitude, zoom: 10.0)
            self.trackLocations = coordinate
            UserDefaults.standard.setValue(trackLocations.latitude, forKey: "trackLocationsLat")
            UserDefaults.standard.setValue(trackLocations.longitude, forKey: "trackLocationsLong")
            self.mapView.isMyLocationEnabled = true
            
            
        }
    }
    
    /*  ********************* Unused Code *************************
     
     
     func cratePin(latitude:Double,longitude:Double){
     
     let myMarker = GMSMarker()
     myMarker.position = CLLocationCoordinate2DMake(latitude, longitude)
     //myMarker.title = self.add
     myMarker.title = "Marker"
     // I have taken a pin image which is a custom image
     let markerImage = UIImage(named: "address")!.withRenderingMode(.alwaysTemplate)
     
     //creating a marker view
     let markerView = UIImageView(image: markerImage)
     
     //changing the tint color of the image
     markerView.tintColor = UIColor.green
     myMarker.map = mapView
     
     mapView.selectedMarker = myMarker // This line is important which opens the snippet
     // drawLineTo(coordinate: coordinate)
     
     let destinationAdd = self.address
     //  NotificationCenter.default.post(name: Notification.Name("destinationAdd"), object: destinationAdd)
     //  print(coordinate)
     
     }
     func showLocations(){
     var bounds = GMSCoordinateBounds()
     for location in locationDict
     {
     let latitude = location["latitude"]
     let longitude = location["longitude"]
     print(latitude)
     let marker = GMSMarker()
     marker.position = CLLocationCoordinate2D(latitude:latitude as! CLLocationDegrees, longitude:longitude as! CLLocationDegrees)
     marker.map = self.mapView
     bounds = bounds.includingCoordinate(marker.position)
     }
     
     mapView.setMinZoom(1, maxZoom: 15)//prevent to over zoom on fit and animate if bounds be too small
     
     let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
     mapView.animate(with: update)
     
     mapView.setMinZoom(1, maxZoom: 20) // allow the user zoom in more than level 15 again
     //    } */
}


extension DashboardVC{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        print("marker tapped:", marker)
        print("marker tapped:", marker.position.latitude)
        staionLat =  marker.position.latitude
        guard let stationid = getStationID(coordinate: marker.position) else {
            return true
        }
        showscreen(stationid: stationid)
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
    
    func showscreen(stationid: String){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"PanelViewVC") as? PanelViewVC{
            vc.stationID = stationid
            self.isSheetAppear = true
            if #available(iOS 15.0, *) {
                if let sheet = vc.sheetPresentationController{
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
            self.navigationController?.present (vc, animated: true)
        }
    }
    
    
    // MARK: - API Call
    
    func getUserApi(){
        let loginUrl  = EndPoints.shared.baseUrlDev +  EndPoints.shared.getUserByPhone
        
        // self.showSpinner(onView: view)
        
        let userMobile = UserDefaults.standard.string(forKey: "userMobile")
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
                
                let statusCode = response.response?.statusCode
                print(statusCode!)
                
                let jsonData = JSON(value)
                print(jsonData)
                
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
                
                UserDefaults.standard.set(fullName, forKey: "userFullName")
                UserDefaults.standard.set(eMail, forKey: "eMail")
                UserDefaults.standard.set(userPk, forKey: "userPk")
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
                print(statusCode)
                
                let jsonData = JSON(value)
                print(jsonData)
                
                let stationId = jsonData.arrayValue.map {$0["stationId"].stringValue}
                let name = jsonData.arrayValue.map {$0["name"].stringValue}
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
                trackLocations.latitude = UserDefaults.standard.value(forKey: "trackLocationsLat") as! CLLocationDegrees
                trackLocations.longitude = UserDefaults.standard.value(forKey: "trackLocationsLong") as! CLLocationDegrees
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
                    print(latitude)
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
                print(self.latTemp)
                print( self.distance)
//                mapView.setMinZoom(1, maxZoom: 15)//prevent to over zoom on fit and animate if bounds be too small
                
//                let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
//                mapView.animate(with: update)
                
                let camera = GMSCameraPosition.camera(withLatitude: trackLocations.latitude, longitude: trackLocations.longitude, zoom: 15.0)
                self.mapView.camera = camera
                
//                mapView.setMinZoom(1, maxZoom: 20) // allow the user zoom in more than level 15 again
                
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    
    
    /* ********************* Unused Code *************************
     
     func getAddrFrmLtLng(latitude:Any, longitude:Any){
     
     let geoCoder = CLGeocoder()
     let location = CLLocation(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
     
     geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
     
     var placeMark: CLPlacemark!
     placeMark = placemarks?[0]
     self.displayLocationInfo(placemark: placeMark)
     
     })
     }
     
     func displayLocationInfo(placemark: CLPlacemark?) -> String    {
     
     var locality =  ""
     var postalCode =  ""
     var administrativeArea = ""
     var country = ""
     var sublocality = ""
     var throughfare = ""
     
     var name = ""
     
     if let containsPlacemark = placemark {
     //stop updating location to save battery life
     //            locationManager.stopUpdatingLocation()
     locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality! : ""
     postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode! : ""
     administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea! : ""
     country = (containsPlacemark.country != nil) ? containsPlacemark.country! : ""
     sublocality = (containsPlacemark.subLocality != nil) ? containsPlacemark.subLocality! : ""
     throughfare = (containsPlacemark.thoroughfare != nil) ? containsPlacemark.thoroughfare! : ""
     
     }
     
     var adr: String  = ""
     
     if throughfare != "" {
     
     adr = throughfare + ", "
     
     }
     if sublocality != "" {
     
     adr = adr + sublocality + ", "
     
     }
     if locality != "" {
     
     adr = adr + locality + ", "
     
     }
     if administrativeArea != "" {
     
     adr = adr + administrativeArea + ", "
     
     }
     if postalCode != "" {
     
     adr = adr + postalCode + ", "
     
     }
     if country != "" {
     
     adr = adr + country
     self.address = adr
     print(adr)
     
     }
     
     return adr
     }
     
     */
}
