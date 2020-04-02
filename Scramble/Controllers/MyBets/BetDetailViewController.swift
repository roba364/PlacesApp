//
//  BetDetailViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 08/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class BetDetailViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var team1ImageView: UIImageView!
    @IBOutlet weak var team2ImageView: UIImageView!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    @IBOutlet weak var ownerBet: UILabel!
    @IBOutlet weak var awardImage: UIImageView!
    @IBOutlet weak var win1button: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var win2Button: UIButton!
    
    //MARK: - Properties
    
    let currentUser = Auth.auth().currentUser
    var selectedMatch: BetInfoModel!
    
    //FIXME: - сюда надо получить данные ссылки до Firebase
    
    var betRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI(match: selectedMatch)
    }
    
    private func updateUI(match: BetInfoModel) {
        
        self.selectedMatch = match
        
        dateLabel.text = selectedMatch.date
        
        if (match.team1logo != nil) && (match.team2logo != nil) && (match.awardImage != nil) {
            
            let url1 = URL(string: match.team1logo!)
            team1ImageView.kf.setImage(with: url1)
            team1ImageView.layer.cornerRadius = 75
            team1ImageView.layer.masksToBounds = true
            team1ImageView.layer.borderColor = UIColor.white.cgColor
            team1ImageView.layer.borderWidth = 1
            team1ImageView.contentMode = .scaleAspectFill
            
            let url2 = URL(string: match.team2logo!)
            team2ImageView.kf.setImage(with: url2)
            team2ImageView.layer.cornerRadius = 75
            team2ImageView.layer.masksToBounds = true
            team2ImageView.layer.borderColor = UIColor.white.cgColor
            team2ImageView.layer.borderWidth = 1
            team2ImageView.contentMode = .scaleAspectFill
            
            let url3 = URL(string: match.awardImage!)
            awardImage.kf.setImage(with: url3)
            
        }
        
        team1Label.text = match.team1
        team2Label.text = match.team2
        
        ownerName.text = match.ownerID
        ownerBet.text = match.ownerResult
        
    }

    @IBAction func winner1ButtonDidTapped(_ sender: Any) {
        
        win1button.setImage(UIImage(named: "win1Red"), for: .normal)
        
        let values = ["status": "confirmed"]
        
        //FIXME: - здесь не могу достучаться до выбранного матча
        
//        .updateChildValues(values)
    }
    
    @IBAction func drawButtonDidTapped(_ sender: Any) {
        
        drawButton.setImage(UIImage(named: "drawRed"), for: .normal)
    }
    
    @IBAction func winner2ButtonDidTapped(_ sender: Any) {
        
        win2Button.setImage(UIImage(named: "win2Red"), for: .normal)
    }
    
    @IBAction func confirmButtonDidTapped(_ sender: Any) {
        
    }
    
}
