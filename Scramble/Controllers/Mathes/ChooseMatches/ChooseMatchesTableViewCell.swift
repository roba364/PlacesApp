//
//  ChooseMatchesTableViewCell.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 18/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ChooseMatchesTableViewCell: UITableViewCell {

    @IBOutlet weak var teamOneImageView: UIImageView!
    @IBOutlet weak var teamTwoImageView: UIImageView!
    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var matchStatusLabel: UILabel!
    
    var matches: AllMatches?
    
    func update(with allmatches: AllMatches) {
        
        self.matches = allmatches
        
        teamOneLabel.text = matches?.team1
        teamTwoLabel.text = matches?.team2
        
        teamOneImageView.contentMode = .scaleAspectFill
        teamTwoImageView.contentMode = .scaleAspectFill
        
        teamOneImageView.layer.cornerRadius = 30
        teamTwoImageView.layer.cornerRadius = 30
        
        teamOneImageView.layer.borderColor = UIColor.white.cgColor
        teamTwoImageView.layer.borderColor = UIColor.white.cgColor
        
        teamOneImageView.layer.borderWidth = 1
        teamTwoImageView.layer.borderWidth = 1
        
        dateLabel.text = allmatches.date
        matchStatusLabel.text = allmatches.matchStatus
        
        
        if (allmatches.team1logo != nil) && (allmatches.team2logo != nil) {
            
            let url1 = URL(string: allmatches.team1logo!)
            teamOneImageView.kf.setImage(with: url1)
            
            let url2 = URL(string: allmatches.team2logo!)
            teamTwoImageView.kf.setImage(with: url2)
        }
    }

}
