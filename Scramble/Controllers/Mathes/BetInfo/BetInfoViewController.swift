//
//  BetInfoViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 05/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class BetInfoViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var team1ImageView: UIImageView!
    @IBOutlet weak var team2ImageView: UIImageView!
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var yourBetNameLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK: - Properties
    
    let currentUser = Auth.auth().currentUser
    let betsRef = Database.database().reference().child("bets")
    var bets = [BetInfoModel]()
    var betRef: DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        fetchBet()
    }
    
    @IBAction func confirmButtonDidTapped(_ sender: Any) {
        
    }
    
    private func setupUI() {
        
        team1ImageView.layer.cornerRadius = 75
        team1ImageView.layer.borderColor = UIColor.white.cgColor
        team1ImageView.layer.borderWidth = 1
        team1ImageView.contentMode = .scaleAspectFill
        
        team2ImageView.layer.cornerRadius = 75
        team2ImageView.layer.borderColor = UIColor.white.cgColor
        team2ImageView.layer.borderWidth = 1
        team2ImageView.contentMode = .scaleAspectFill
    }
    
    private func fetchBet() {
        
        betsRef.observe(.childAdded) { [weak self] (snapshot) in
      
            guard let self = self else { return }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let bet = BetInfoModel()
                bet.setValuesForKeys(dict)
                self.dateLabel.text = bet.date
                
                if (bet.team1logo != nil) && (bet.team2logo != nil) {
                    let url1 = URL(string: bet.team1logo!)
                    self.team1ImageView.kf.setImage(with: url1)
                    
                    let url2 = URL(string: bet.team2logo!)
                    self.team2ImageView.kf.setImage(with: url2)
                }
                
                self.team1Label.text = bet.team1
                self.team2Label.text = bet.team2
                
                self.friendNameLabel.text = bet.enemyUsername
                self.yourBetNameLabel.text = bet.ownerResult
            }
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPendingBetsVC" {
            if let vc = segue.destination as? PendingBetViewController {
                vc.betRef = betRef
            }
    }
}
}
