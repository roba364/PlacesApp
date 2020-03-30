//
//  MapViewController.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 27/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol MapViewControllerDelegate {
    func getAddress(_ address: String)
}

class MapViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapPin: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var goButton: UIButton!
    
    //MARK: - Properties
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    let annotationIdentifier = "annotationIdentifier"
    let locationManager = CLLocationManager()
    let regionInMeters = 1_000.00
    var incomeSegueIdentifier = ""
    
    // saved directions array
    
    var directionsArray: [MKDirections] = []
    
    // get place coordinate to use it
    var placeCoordinate: CLLocationCoordinate2D?
    
    // property for previous user's location
    var previousLocation: CLLocation? {
        didSet {
            startTrackingUserLocation()
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        mapView.delegate = self
        
        setupMapView()
        checkLocationServices()
    }
    
    //MARK: - Actions

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func userLocationTapped(_ sender: Any) {
        
        //check actual user location
        showUserLocation()
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        getDirections()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let address = addressLabel.text, !address.isEmpty else { return }
        
        mapViewControllerDelegate?.getAddress(address)
        
        dismiss(animated: true)
    }
    
    //MARK: - Helper functions
    
    private func setupMapView() {
        
        goButton.isHidden = true
        
        if incomeSegueIdentifier == "showMapVC" {
            setupPlaceMark()
            mapPin.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    private func resetMapView(with newDirections: MKDirections) {
        
        // we need to remove the old one to impose a new route
        
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(newDirections)
        let _ = directionsArray.map { $0.cancel() }
        directionsArray.removeAll()
    }
    
    private func setupPlaceMark() {
        
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
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
        
            // anchor the annotation to current selected point on the map.
            
            guard let placeMarkLocation = placeMark?.location else { return }
            
            annotation.coordinate = placeMarkLocation.coordinate
            self.placeCoordinate = placeMarkLocation.coordinate
            
            // define a visible map area with all annotations created.
            
            self.mapView.showAnnotations([annotation], animated: true)
            
            // highlight selected annotation
            
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    private func checkLocationServices() {
        
        if CLLocationManager.locationServicesEnabled() {
            //check geolocation
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                
                guard let self = self else { return }
                
                self.showAlert(title: "Location services are not available",
                          message: "To give permission go to: Settings -> Privace -> Locations services and turn on")
            }
            
        }
    }
    
    private func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            if incomeSegueIdentifier == "getAddress" { showUserLocation() }
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
    
    private func showUserLocation() {
        
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: regionInMeters,
                                            longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func startTrackingUserLocation() {
        
        // update previous user location and show user in the center of the map view
        // when user moves - update coordinates and show user in the center again
        
        guard let previousLocation = previousLocation else { return }
        
        let center = getCenterLocation(for: mapView)
        
        // if previous location more than 50 meters
        
        guard center.distance(from: previousLocation) > 50 else { return }
        
        // get new coordinates to previous location
        
        self.previousLocation = center
        
        // show updated user location for current route with delay 3 seconds
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            
            guard let self = self else { return }
            
            self.showUserLocation()
        }
        
        
    }
    
    private func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    private func showAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func getDirections() {
        
        guard let location = locationManager.location?.coordinate else {
            showAlert(title: "Error", message: "Current location is not found")
            return }
        
        locationManager.startUpdatingLocation()
        previousLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        
        guard let request = createDirectionsRequest(from: location) else {
            showAlert(title: "Error", message: "Destination is not found")
            return }
        
        // create a route based on what is available in the request.
        
        let directions = MKDirections(request: request)
        
        // reset routes before create a new one
        
        resetMapView(with: directions)
        
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
                
                self.mapView.addOverlay(route.polyline)
                
                // focus the map so that the whole route is visible.
                
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                
                // distance and expected travel time
                
                let distance = String(format: "%.1f", route.distance / 1000)
                let travelTime = route.expectedTravelTime
                
                print("Distance: \(distance)")
                print("Expected travel time: \(travelTime)")
            }
        }
    }
    
    private func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request? {
        
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
    
    
}

    //MARK: - Extension

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        // setup selected place icon for clip on the map
        
        if let imageData = place.imageData {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.image = UIImage(data: imageData)
            annotationView?.rightCalloutAccessoryView = imageView
        }
        
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        if incomeSegueIdentifier == "getAddress" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.showUserLocation()
            }
        }
        
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            // get the name and number
            
            let streetName = placemark?.thoroughfare
            let buildNumber = placemark?.subThoroughfare
            
            DispatchQueue.main.async {
                if streetName != nil && buildNumber != nil {
                    self.addressLabel.text = "\(streetName!), \(buildNumber!)"
                } else if streetName != nil {
                    self.addressLabel.text = "\(streetName!)"
                } else {
                    self.addressLabel.text = ""
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolygonRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        
        return renderer
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        checkLocationAuthorization()
    }
}
