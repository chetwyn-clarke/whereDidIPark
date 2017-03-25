//
//  ViewController.swift
//  Where's My Car?
//
//  Created by Chetwyn on 3/23/17.
//  Copyright © 2017 Clarke Enterprises. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var parkBtn: RoundButton!
    
    let regionRadius: CLLocationDistance = 500
    
    var parkedCarAnnotation: ParkingSpot?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        checkLocationAuthorizationStatus()
    }
    
    @IBAction func parkBtnPressed(_ sender: Any) {
        
        // When pressed, check to see if there is a parking postion already.  If there is, change the button to found car; if not, we create a parking spot.  Then center the map on user's location.
        
        if mapView.annotations.count == 1 {
            
            mapView.addAnnotation(parkedCarAnnotation!)
            parkBtn.setImage(UIImage(named: "foundCar.png"), for: .normal)
            
        } else {
            
            mapView.removeAnnotations(mapView.annotations)
            parkBtn.setImage(UIImage(named: "parkCar.png"), for: .normal)
            
        }
        
        centerMapOnLocation(location: LocationService.instance.locationManager.location!)
        
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            LocationService.instance.locationManager.delegate = self
            LocationService.instance.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            LocationService.instance.locationManager.startUpdatingLocation()
        } else {
            LocationService.instance.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ParkingSpot {
            let identifier = "pin"
            var view: MKPinAnnotationView
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.animatesDrop = true
            view.pinTintColor = UIColor.orange
            view.calloutOffset = CGPoint(x: -8, y: -3)
            view.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
            return view
        } else {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! ParkingSpot
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.mapItem(location: (parkedCarAnnotation?.coordinate)!).openInMaps(launchOptions: launchOptions)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    // When user location is updated, we will save the location to the LocationService, and instantiate ParkedCarAnnotation.
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        centerMapOnLocation(location: CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude))
        
        let locationServiceCoordinate = LocationService.instance.locationManager.location!.coordinate
        
        parkedCarAnnotation = ParkingSpot(title: "My Parking Spot", locationName: "Tap the 'i' for GPS", coordinate: CLLocationCoordinate2D(latitude: locationServiceCoordinate.latitude, longitude: locationServiceCoordinate.longitude))
    }
    
}

