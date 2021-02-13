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
import MapKit

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet private var mapView: MKMapView!
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
        //request current location
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
            self.lat = locValue.latitude
            self.long = locValue.longitude
        }
        //center to current location
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        let initialLocation = CLLocation(latitude:self.lat, longitude: self.long)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.centerToLocation(initialLocation)
        //zoom
        let region = MKCoordinateRegion(
          center: initialLocation.coordinate,
          latitudinalMeters: 50000,
          longitudinalMeters: 60000)
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        //add annotation for current location
        // Show artwork on map
        mapView.delegate = self
        let marker = MapMarker(
          title: "Current Location",
          locationName: "Current Location",
            coordinate: CLLocationCoordinate2D(latitude: self.lat, longitude: self.long))
        mapView.addAnnotation(marker)

        
        
        //        //display google map
        //        let camera = GMSCameraPosition.camera(withLatitude: lat , longitude: long, zoom: 15.0)
        //        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        //        self.view.addSubview(mapView)
        //        // Creates a marker on current location
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        //        marker.icon = GMSMarker.markerImage(with: .black)
        //        marker.map = mapView
        
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
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "LocationInfoView", sender: view)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         let destination = segue.destination as? LocationInfoViewController
//            let annotationView = sender as? MKPinAnnotationView {
//            destination.annotation = annotationView.annotation as? MKPointAnnotation
//        }
    }
}
private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
class CustomAnnotationView: MKPinAnnotationView {  // or nowadays, you might use MKMarkerAnnotationView
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .infoLight)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



