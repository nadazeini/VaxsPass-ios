//
//  MapViewController.swift
//  VaxsPass
//
//  Created by Nada Zeini on 2/12/21.
//

import UIKit
import ArcGIS

class MapViewController: UIViewController, AGSGeoViewTouchDelegate {
    @IBOutlet weak var mapView: AGSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        addGraphics()
        navigationItem.rightBarButtonItem = directionsButton
    }
    
    private func setupMap() {
        mapView.touchDelegate = self
        let map = AGSMap(
            basemapStyle: .arcGISTopographic
        )
        mapView.map = map
        mapView.setViewpoint(
            AGSViewpoint(
                latitude: 34.02700,
                longitude: -118.80500,
                scale: 72_000
            )
        )
        mapView.map = AGSMap(basemapType: .navigationVector, latitude: 34.09042, longitude: -118.71511, levelOfDetail: 10)

        // *** ADD ***
        let portal = AGSPortal(url: URL(string: "https://www.arcgis.com")!, loginRequired: false)
        let item = AGSPortalItem(portal: portal, itemID: "2e4b3df6ba4b44969a3bc9827de746b3")
        
        // *** ADD ***
        let layer = AGSFeatureLayer(item: item, layerID: 0)
        mapView.map!.operationalLayers.add(layer)
    }
    
    private let startGraphic: AGSGraphic = {
        let symbol = AGSSimpleMarkerSymbol(style: .circle, color: .white, size: 8)
        symbol.outline = AGSSimpleLineSymbol(style: .solid, color: .black, width: 1)
        let graphic = AGSGraphic(geometry: nil, symbol: symbol)
        return graphic
    }()
    
    private let endGraphic: AGSGraphic = {
        let symbol = AGSSimpleMarkerSymbol(style: .circle, color: .black, size: 8)
        symbol.outline = AGSSimpleLineSymbol(style: .solid, color: .black, width: 1)
        let graphic = AGSGraphic(geometry: nil, symbol: symbol)
        return graphic
    }()
    
    private let routeGraphic: AGSGraphic = {
        let symbol = AGSSimpleLineSymbol(style: .solid, color: .blue, width: 3)
        let graphic = AGSGraphic(geometry: nil, symbol: symbol)
        return graphic
    }()
    
    private func addGraphics() {
        let routeGraphics = AGSGraphicsOverlay()
        mapView.graphicsOverlays.add(routeGraphics)
        routeGraphics.graphics.addObjects(from: [routeGraphic, startGraphic, endGraphic])
    }
    
    private enum RouteBuilderStatus {
        case none
        case selectedStart(AGSPoint)
        case selectedStartAndEnd(AGSPoint, AGSPoint)
        case routeSolved(AGSPoint, AGSPoint, AGSRoute)
        
        func nextStatus(with point: AGSPoint) -> RouteBuilderStatus {
            switch self {
            case .none:
                return .selectedStart(point)
            case .selectedStart(let start):
                return .selectedStartAndEnd(start, point)
            case .selectedStartAndEnd:
                return .selectedStart(point)
            case .routeSolved:
                return .selectedStart(point)
            }
        }
        
    }
    private var status: RouteBuilderStatus = .none {
        didSet {
            switch status {
            case .none:
                startGraphic.geometry = nil
                endGraphic.geometry = nil
                routeGraphic.geometry = nil
                directionsButton.isEnabled = false
            case .selectedStart(let start):
                startGraphic.geometry = start
                endGraphic.geometry = nil
                routeGraphic.geometry = nil
                directionsButton.isEnabled = false
            case .selectedStartAndEnd(let start, let end):
                startGraphic.geometry = start
                endGraphic.geometry = end
                routeGraphic.geometry = nil
                directionsButton.isEnabled = false
            case .routeSolved(let start, let end, let route):
                startGraphic.geometry = start
                endGraphic.geometry = end
                routeGraphic.geometry = route.routeGeometry
                directionsButton.isEnabled = true
            }
        }
    }
    @objc
    func displayDirections(_ sender: AnyObject) {
        guard case let .routeSolved(_, _, route) = status else { return }
        let directions = route.directionManeuvers.enumerated()
            .reduce(into: "\n") { $0 += "\($1.offset + 1). \($1.element.directionText).\n\n" }
        let alert = UIAlertController(title: "Directions", message: directions, preferredStyle: .alert)
        let okay = UIAlertAction(title: "Hide Directions", style: .default, handler: nil)
        alert.addAction(okay)
        present(alert, animated: true, completion: nil)
    }
    
    private lazy var directionsButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Show Directions", style: .plain, target: self, action: #selector(displayDirections))
        button.isEnabled = false
        return button
    }()
    
}
extension ViewController: AGSGeoViewTouchDelegate {
    
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        
    }
}
