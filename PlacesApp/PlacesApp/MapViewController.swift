//
//  MapViewController.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 27/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Properties
    
    var place: Place!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlaceMark()
    }
    
    //MARK: - Actions

    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Helper functions
    
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
            
            // define a visible map area with all annotations created.
            
            self.mapView.showAnnotations([annotation], animated: true)
            
            // highlight selected annotation
            
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
    
}
