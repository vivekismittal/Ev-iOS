//
//  LocationManager.swift
//  EVApp
//
//  Created by Brijesh Bhardwaj on 27/05/23.
//

import Foundation
import Foundation
import CoreLocation

struct LocationAddress{
    var location:CLLocation
    var city : String?
    var country:String?
    var address:String?
    
    init(location: CLLocation) {
        self.location = location
    }
    
}
typealias handler = () -> ()?

class LocationManager:NSObject{
    public static let shared = LocationManager()
    
    var locationUpdated: handler?
    var curentLocation: LocationAddress?
    
    private var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        
        return locationManager
    }()
    
    func startLocationUpdater(completed:handler?){
        locationUpdated = completed
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        guard let firstLocation = locations.first else{return}
        if CLLocationCoordinate2DIsValid(firstLocation.coordinate){
            print(firstLocation.coordinate)
            
            curentLocation = .init(location: firstLocation)
        }
        if let update = locationUpdated{
            update()
        }
                
    }
    
}
