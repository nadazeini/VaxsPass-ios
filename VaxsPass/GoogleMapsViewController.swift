//
//  GoogleMapsViewController.swift
//  VaxsPass
//
//  Created by Nada Zeini on 2/12/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var lat: Double = 0.0
    var long: Double = 0.0
    var apiKey = "AIzaSyARNJeV0HUI1CcAVuKN6VQ__PwET2KZ6Rc"
    
    
    lazy var googleClient: GoogleClientRequest = GoogleClient()
    var currentLocation: CLLocation = CLLocation(latitude: 42.361145, longitude: -71.057083)
    var locationName : String = "Starbucks"
    var searchRadius : Int = 2500
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            lat = locValue.latitude
            long = locValue.longitude
        }
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        marker.map = mapView
        
        //        var googleURLString = NSString(format:"https://maps.googleapis.com/maps/api/place/search/json?location=[lat],[lon]&radius=[radius]&types=[type]&key=kGOOGLE_API_KEY&sensor=true",lat, long, 10, type, apiKey )
    }
}
extension ViewController {
    func fetchGoogleData(forLocation: CLLocation, locationName: String, searchRadius: Int) {
        googleClient.getGooglePlacesData(forKeyword: locationName, location: currentLocation, withinMeters: 2500) { (response) in
            //Do something with the response
        }
    }
}

