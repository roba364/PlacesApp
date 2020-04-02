//
//  MakeYourBetViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 25/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MakeYourBetViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var matchStatusLabel: UILabel!
    
    @IBOutlet weak var teamOneImageView: UIImageView!
    @IBOutlet weak var teamTwoImageView: UIImageView!
    @IBOutlet weak var chooseYourFriendButton: UIButton!
    @IBOutlet weak var win1Button: UIButton!
    @IBOutlet weak var drawButton: UIButton!
    @IBOutlet weak var win2Button: UIButton!
    
    //MARK: - Properties
    
    var allMatches: AllMatches!
    let currentUser = Auth.auth().currentUser
    
    var betRef: DatabaseReference?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPassedUI()
    }
    
    //MARK: - Actions
    
    @IBAction func win1ButtonDidTapped(_ sender: Any) {
        
        win1Button.setImage(UIImage(named: "win1Red"), for: .normal)
        
        let values = ["ownerResult": "winner1"]
        
        betRef?.updateChildValues(values)

    }
    
    @IBAction func drawButtonDidTapped(_ sender: Any) {
            
        drawButton.setImage(UIImage(named: "drawRed"), for: .normal)
        
        let values = ["ownerResult": "draw"]
        
        betRef?.updateChildValues(values)

    }
    
    @IBAction func win2ButtonDidTapped(_ sender: Any) {
               
        win2Button.setImage(UIImage(named: "win2Red"), for: .normal)
        
        let values = ["ownerResult": "winner2"]
        
        betRef?.updateChildValues(values)
    }
    
    @IBAction func chooseYourFriendTapped(_ sender: Any) {
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectedBet" {
            if let vc = segue.destination as? ChooseYourFriendViewController {
                vc.betRef = betRef
            }
        }
    }
    //MARK: - Helper functions
    
    private func setupPassedUI() {
        
        guard
            let teamlogo1 = allMatches.team1logo,
            let teamlogo2 = allMatches.team2logo
        else { return }
        
        dateLabel.text = allMatches.date
        matchStatusLabel.text = allMatches.matchStatus
        
        let url1 = URL(string: teamlogo1)
        teamOneImageView.kf.setImage(with: url1)
        teamOneImageView.layer.cornerRadius = 75
        teamOneImageView.layer.masksToBounds = true
        teamOneImageView.layer.borderColor = UIColor.white.cgColor
        teamOneImageView.layer.borderWidth = 1
        teamOneImageView.contentMode = .scaleAspectFill
        
        
        let url2 = URL(string: teamlogo2)
        teamTwoImageView.kf.setImage(with: url2)
        
        teamTwoImageView.layer.cornerRadius = 75
        teamTwoImageView.layer.masksToBounds = true
        teamTwoImageView.layer.borderColor = UIColor.white.cgColor
        teamTwoImageView.layer.borderWidth = 1
        teamTwoImageView.contentMode = .scaleAspectFill
    }
}
