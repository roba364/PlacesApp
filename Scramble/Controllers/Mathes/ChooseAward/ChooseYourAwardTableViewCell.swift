//
//  ChooseYourAwardTableViewCell.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 04/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Kingfisher

class ChooseYourAwardTableViewCell: UITableViewCell {

    @IBOutlet weak var awardImageView: UIImageView!
    @IBOutlet weak var awardLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var awards: Award?
    
    
    func update(with awards: Award) {
        
        self.awards = awards
        
        if awards.imageUrl != nil {
            let url = URL(string: awards.imageUrl!)
            awardImageView.kf.setImage(with: url)
        }
        awardLabel.text = awards.name
        cellView.layer.cornerRadius = 15
    }
}
