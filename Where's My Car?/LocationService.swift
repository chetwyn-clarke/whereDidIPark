//
//  LocationService.swift
//  Where's My Car?
//
//  Created by Chetwyn on 3/24/17.
//  Copyright © 2017 Clarke Enterprises. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let instance = LocationService()
    
    var locationManager = CLLocationManager()
    
    var currentLocation: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 50
        self.locationManager.startUpdatingLocation()
    }
    
    @nonobjc func locationManager(_ manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.currentLocation = locationManager.location?.coordinate
    }
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.currentLocation = locationManager.location?.coordinate
//    }
    

}
