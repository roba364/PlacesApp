//
//  PlacesTableViewCell.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 25/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func update(with place: Place) {
        
        placeImageView.image = UIImage(data: place.imageData!)
        placeNameLabel.text = place.name
        locationLabel.text = place.location
        typeLabel.text = place.type
        
        placeImageView.clipsToBounds = true
        placeImageView.layer.cornerRadius = placeImageView.frame.size.height / 2
    }
    
}
