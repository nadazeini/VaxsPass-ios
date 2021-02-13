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
    var locations: [Place.Location.LatLong] = []
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
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.map = mapView
        
        //        var googleURLString = NSString(format:"https://maps.googleapis.com/maps/api/place/search/json?location=[lat],[lon]&radius=[radius]&types=[type]&key=kGOOGLE_API_KEY&sensor=true",lat, long, 10, type, apiKey )
        let googleUrl = googlePlacesDataURL(forKey: apiKey, location: locValue, keyword: "covid19_vaccine_locations")
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: googleUrl) { (responseData, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = responseData, let response = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                print("something happened")
                
                return
            }
            for place in response.results {
                self.locations.append(place.geometry.location)
            }
            print(self.locations)
            for loc in self.locations{
                let position = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
                let markers = GMSMarker(position: position)
                markers.icon = GMSMarker.markerImage(with: .black)
                markers.title = "Vaccine Place"
//                let camera1 = GMSCameraPosition.camera(withLatitude: loc.latitude , longitude: loc.longitude, zoom: 15.0)
//                let mapView1 = GMSMapView.map(withFrame: self.view.frame, camera: camera)
//                markers.map = mapView1
                print("done")
            }
        }
        print(self.locations)
        
        task.resume()
    }
    func googlePlacesDataURL(forKey apiKey: String, location: CLLocationCoordinate2D, keyword: String) -> URL {
        
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        let locationString = "location=\(location.latitude),\(location.longitude)"
        let rankby = "rankby=distance"
        let keywrd = "keyword=" + keyword
        let key = "key=" + apiKey
        
        return URL(string: baseURL + locationString + "&" + rankby + "&" + keywrd + "&" + key)!
    }
}




