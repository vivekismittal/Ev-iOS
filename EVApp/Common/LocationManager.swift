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
    var currentLocation: LocationAddress?
    
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
    
    func getDistance(from location: StationChargerAddress) -> Float{
        let coordinate = currentLocation?.location.coordinate
        
        let curLocation = CLLocation(latitude: coordinate?.latitude ?? 00.00, longitude: coordinate?.longitude ?? 00.00)
        
        let latitude = Double(location.latitude ?? "") ?? 0
        let longitude = Double(location.longitude ?? "") ?? 0
        let charLocation = CLLocation(latitude: latitude, longitude: longitude)
        let totDistance = curLocation.distance(from: charLocation)
        return Float(totDistance / 1000)
    }
    
}

extension LocationManager:CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]){
        guard let firstLocation = locations.first else{return}
        if CLLocationCoordinate2DIsValid(firstLocation.coordinate){
            print(firstLocation.coordinate)
            
            currentLocation = .init(location: firstLocation)
        }
        if let update = locationUpdated{
            update()
        }
                
    }
    
}
