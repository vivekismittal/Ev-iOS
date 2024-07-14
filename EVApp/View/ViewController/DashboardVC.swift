//
//  DashboardVC.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 19/05/23.
//  Corrected by Vivek Mittal
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON


class DashboardVC: UIViewController{
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnStation: UIButton!
    
    var isSheetAppear = false
    let zoomedParameter: Float = 18.5
    private var availableChargersStationViewModel: AvailableChargersViewModel = getAvailableChargerViewModel()
    private var isLocationUpdatingFirstTime = true
    
    @objc func methodOfReceivedNotification(notification: Notification){
        let nextViewController = WelcomeVC.instantiateUsingStoryboard()
        self.navigationController?.present(nextViewController, animated: true, completion: nil)
    }
    
    static func instantiateUsingStoryboard() -> Self {
        let dashboardVC = ViewControllerFactory<DashboardVC>.viewController(for: .HomeDashboard)
        return dashboardVC as! Self
    }
    
    static func getAvailableChargerViewModel() -> AvailableChargersViewModel{
        return AvailableChargersViewModel.shared
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkUpdateVersion(viewController: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.mapView.setNeedsLayout()
        self.mapView.layoutIfNeeded()
        
        self.mapView.delegate = self
        btnStation.layer.cornerRadius = 30
        
//        if let currentLocation = LocationManager.shared.curentLocation{
//            let coordinate = currentLocation.location.coordinate
//        }
        
        getData()
        getUserApi()
        
        self.mapView.isMyLocationEnabled = true
        LocationManager.shared.startLocationUpdater{
            self.showLocation()
        }
    }
    
    func getData(){
        self.showSpinner(onView: view)
        availableChargersStationViewModel.fetchSortedAvailableChargingStations(sorted: false){ [weak self] res in
            switch res{
            case .success(_):
                DispatchQueue.main.async{
                    self?.removeSpinner()
                    self?.setView()
                }
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func setView(){
        availableChargersStationViewModel.availableChargingStations.forEach { charger in
            if let latitude = charger.stationChargerAddress?.latitude, let longitude = charger.stationChargerAddress?.longitude, let latitudeFloat = Float(latitude), let longitudeFloat = Float(longitude){
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitudeFloat), longitude: CLLocationDegrees(longitudeFloat))
                marker.icon = #imageLiteral(resourceName: "yahhvi")
                marker.map = self.mapView
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func menuClicked(_ sender: Any) {
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
        if let currentLocation = LocationManager.shared.currentLocation{
            let coordinate = currentLocation.location.coordinate
            self.mapView.camera = .init(latitude:coordinate.latitude,longitude: coordinate.longitude, zoom: self.isLocationUpdatingFirstTime ? self.zoomedParameter : self.mapView.camera.zoom )
            isLocationUpdatingFirstTime = false
            UserAppStorage.trackLocationsLat = coordinate.latitude
            UserAppStorage.trackLocationsLong = coordinate.longitude
        }
    }
    // MARK: - API Call
    func getUserApi(){
        let loginUrl  = EndPoints.shared.baseUrlDev +  EndPoints.shared.getUserByPhone
        
        let userMobile = UserAppStorage.userMobile
        let parameters = [
            "mobileNumber": userMobile
        ] as? [String:AnyObject]
        
        AF.request(loginUrl, method: .post, parameters: parameters! as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            
            switch (response.result) {
                
            case .success(let value):
                print(response)
                
                let jsonData = JSON(value)
                let firstName = jsonData["firstName"].string
                let eMail = jsonData["eMail"].string
                let lastName = jsonData["lastName"].string
                let userPk = jsonData["userPk"].intValue
                
                
                let fullName = (firstName ?? "")  + (lastName ?? "")
                
                
                UserAppStorage.userFullName = fullName
                UserAppStorage.email = eMail ?? ""
                UserAppStorage.userPk = userPk
                
                print(userPk)
                break
            case .failure:
                print(Error.self)
                
            }
        }
    }
    
}


extension DashboardVC: GMSMapViewDelegate{
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let charger = availableChargersStationViewModel.availableChargingStations.first { Float($0.stationChargerAddress?.latitude ?? "") ==  Float(marker.position.latitude) && Float($0.stationChargerAddress?.longitude ?? "") ==  Float(marker.position.longitude)
        }
        
        openBottomPanel(stationID: charger?.stationId)
        return true
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
