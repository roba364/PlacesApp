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
    
    let mapManager = MapManager()
    
    var mapViewControllerDelegate: MapViewControllerDelegate?
    var place = Place()
    
    let annotationIdentifier = "annotationIdentifier"
    var incomeSegueIdentifier = ""
    
    // property for previous user's location
    var previousLocation: CLLocation? {
        didSet {
            mapManager.startTrackingUserLocation(
                for: mapView,
                and: previousLocation) { (currentLocation) in
                    
                self.previousLocation = currentLocation
                                                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.mapManager.showUserLocation(mapView: self.mapView)
                    }
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = ""
        mapView.delegate = self
        
        setupMapView()
    }
    
    //MARK: - Actions

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func userLocationTapped(_ sender: Any) {
        
        //check actual user location
        mapManager.showUserLocation(mapView: mapView)
    }
    
    @IBAction func goButtonTapped(_ sender: Any) {
        mapManager.getDirections(for: mapView) { (location) in
  
            self.previousLocation = location
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        guard let address = addressLabel.text, !address.isEmpty else { return }
        
        mapViewControllerDelegate?.getAddress(address)
        
        dismiss(animated: true)
    }
    
    //MARK: - Helper functions
    
    private func setupMapView() {
        
        goButton.isHidden = true
        
        mapManager.checkLocationServices(mapView: mapView, segueIdentifier: incomeSegueIdentifier) {
            mapManager.locationManager.delegate = self
        }
        
        if incomeSegueIdentifier == "showMapVC" {
            mapManager.setupPlaceMark(place: place, mapView: mapView)
            mapPin.isHidden = true
            addressLabel.isHidden = true
            doneButton.isHidden = true
            goButton.isHidden = false
        }
    }
    
    deinit {
        print("deinit", MapViewController.self)
    }
}

    //MARK: - Extension

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            
            annotationView = MKPinAnnotationView(annotation: annotation,
                                                  reuseIdentifier: annotationIdentifier)
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
        
        let center = mapManager.getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        if incomeSegueIdentifier == "getAddress" && previousLocation != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {

                self.mapManager.showUserLocation(mapView: mapView)
            }
        }
        
        geoCoder.cancelGeocode()
        
        geoCoder.reverseGeocodeLocation(center) { (placemarks, error) in
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
    
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        mapManager.checkLocationAuthorization(mapView: mapView,
                                              segueIdentifier: incomeSegueIdentifier)
    }
}
