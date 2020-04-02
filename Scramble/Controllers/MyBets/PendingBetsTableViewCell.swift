//
//  ConfirmedBetsTableViewCell.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 06/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class PendingBetsTableViewCell: UITableViewCell {

    @IBOutlet weak var team1ImageView: UIImageView!
    @IBOutlet weak var team2ImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var awardLabel: UILabel!
    @IBOutlet weak var awardImage: UIImageView!
    @IBOutlet weak var friendLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    var bet: BetInfoModel?
    
    func update(with bet: BetInfoModel) {
        
        self.bet = bet
        
        if (bet.team1logo != nil) && (bet.team2logo != nil) && (bet.awardImage != nil) {

            let url1 = URL(string: bet.team1logo!)
            team1ImageView.kf.setImage(with: url1)

            let url2 = URL(string: bet.team2logo!)
            team2ImageView.kf.setImage(with: url2)
            
            let url3 = URL(string: bet.awardImage!)
            awardImage.kf.setImage(with: url3)
        }
        cellView.layer.cornerRadius = 15
        
        team1ImageView.layer.cornerRadius = 40
        team1ImageView.layer.borderColor = UIColor.white.cgColor
        team1ImageView.layer.borderWidth = 1
        team1ImageView.contentMode = .scaleAspectFill
        
        team2ImageView.layer.cornerRadius = 40
        team2ImageView.layer.borderColor = UIColor.white.cgColor
        team2ImageView.layer.borderWidth = 1
        team2ImageView.contentMode = .scaleAspectFill
        
            dateLabel.text = bet.date
            resultLabel.text = bet.ownerResult
            awardLabel.text = bet.award
            friendLabel.text = bet.enemyUsername

    }
}
