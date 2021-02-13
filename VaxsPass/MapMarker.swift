//
//  MapMarker.swift
//  VaxsPass
//
//  Created by Nada Zeini on 2/13/21.
//

import Foundation
import MapKit

class MapMarker: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let coordinate: CLLocationCoordinate2D
    init(
        title: String?,
        locationName: String?,
        coordinate: CLLocationCoordinate2D
    ) {
        self.title = title
        self.locationName = locationName
        self.coordinate = coordinate
        super.init()
    }
    var subtitle: String? {
        return locationName
    }
}
