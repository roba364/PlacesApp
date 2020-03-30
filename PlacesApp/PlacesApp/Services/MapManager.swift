//
//  MapManager.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 30/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import MapKit

class MapManager {
    
    //MARK: - Properties
    
    let locationManager = CLLocationManager()
    
    private let regionInMeters = 1_000.00
    
    // saved directions array
    private var directionsArray: [MKDirections] = []
    
    // get place coordinate to use it
    private var placeCoordinate: CLLocationCoordinate2D?
    
    //MARK: - Helper functions
    
    func setupPlaceMark(place: Place, mapView: MKMapView) {
        
        //get current address
        
        guard let location = place.location else { return }
        
        // create object for geographical transformation of string address
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(location) { [weak self] (placeMarks, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                  let placeMarks = placeMarks,
                  let self = self
                else { return }
            
            // we're looking for a location at current address, we take the first index.
            
            let placeMark = placeMarks.first
            
            // to describe the point that the marker points to, you have to create an annotation.
            
            let annotation = MKPointAnnotation()
            annotation.title = place.name
            annotation.subtitle = place.type
        
            // anchor the annotation to current selected point on the map.
            
            guard let placeMarkLocation = placeMark?.location else { return }
            
            annotation.coordinate = placeMarkLocation.coordinate
            self.placeCoordinate = placeMarkLocation.coordinate
            
            // define a visible map area with all annotations created.
            
            mapView.showAnnotations([annotation], animated: true)
            
            // highlight selected annotation
            
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    
    
    func checkLocationServices(mapView: MKMapView, segueIdentifier: String, closure: () -> ()) {
        
        // geolocation service availability check
        
        if CLLocationManager.locationServicesEnabled() {
            //check geolocation
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            checkLocationAuthorization(mapView: mapView, segueIdentifier: segueIdentifier)
            closure()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                
                guard let self = self else { return }
                
                self.showAlert(title: "Location services are not available",
                          message: "To give permission go to: Settings -> Privace -> Locations services and turn on")
            }
        }
    }
    
    func checkLocationAuthorization(mapView: MKMapView, segueIdentifier: String) {
        
        // application authorization verification for geolocation services
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if segueIdentifier == "getAddress" { showUserLocation(mapView: mapView) }
            break
        case .denied:
            // show alert
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // show alert
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("new case")
        }
    }
    
    func showUserLocation(mapView: MKMapView) {
        
        // localization focus on user
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func resetMapView(with newDirections: MKDirections, mapView: MKMapView) {
        
        // we need to remove the old one route  before building a new one
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(newDirections)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    func getDirections(for mapView: MKMapView, previousLocation: (CLLocation) -> ()) {
        
        // create a route from a user's location to a point on the map
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return }
        
        locationManager.startUpdatingLocation()
        previousLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
        
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return }
        
        // create a route based on what is available in the request.
        
        let directions = MKDirections(request: request)
        
        // reset routes before create a new one
        
        resetMapView(with: directions, mapView: mapView)
        
        directions.calculate { [weak self] (response, error) in
            
            guard let self = self else { return }
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let response = response else {
                self.showAlert(title: "Error", message: "Directions is not available")
                return }
            
            // the response object contains an array of routes
            // these are possible directions for user
            // each route object contains geometry information
            // that can be used to show the route on the map
            // as well as additional information such as expected travel time, distance and other route notifications
            // using all this data, we can draw a route on the map.
            
            for route in response.routes {
                
                // add detailed geometry all the route
                
                mapView.addOverlay(route.polyline)
                
                // focus the map so that the whole route is visible.
                
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                // distance and expected travel time
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let travelTime = route.expectedTravelTime
                
                print("Distance: \(distance)")
                print("Expected travel time: \(travelTime)")
            }
        }
    }
    
    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
        // routing request setting
        // get final point
        
        guard let destinationCoordinate = placeCoordinate else { return nil }
        
        // get starting point
        let startingLocation = MKPlacemark(coordinate: coordinate)
        
        // get destination point
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        
        // create object which get the properties and will be return
        // build a route
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        // map center detection
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func startTrackingUserLocation(for mapView: MKMapView,
                                           and location: CLLocation?,
                                           closure: (_ currentLocation: CLLocation) -> () ) {
        
        // update previous user location and show user in the center of the map view
        // when user moves - update coordinates and show user in the center again
        
        guard let location = location else { return }
        
        let center = getCenterLocation(for: mapView)
        
        // if previous location more than 50 meters
        
        guard center.distance(from: location) > 50 else { return }
        
        // get new coordinates to previous location
        
        closure(center)
    }
    
    private func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true)
    }
}
