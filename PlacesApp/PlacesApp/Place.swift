//
//  Place.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 25/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

struct Place {
    
    var name: String
    var location: String?
    var type: String?
    var image: UIImage?
    var placeImage: String?
    
    static let places = ["1067", "Monkeyfood", "DEPO", "VinnieJonhs", "Beercap"]
    
    static func randomPlaces() -> [Place] {
        
        var places = [Place]()
        
        for place in self.places {
            
            places.append(Place(name: place, location: "Minsk", type: "Restaraunt", image: nil, placeImage: place))
            
        }
        
        return places
    }
    
}
