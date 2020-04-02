//
//  ConfirmedBetViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 05/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class ConfirmedBetViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var friendUsername: UILabel!
    @IBOutlet weak var awardLabel: UILabel!
    @IBOutlet weak var awardImageView: UIImageView!
    
    //MARK: - Properties
    
    let currentUser = Auth.auth().currentUser
    let betsRef = Database.database().reference().child("bets")
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBet()
    }
    
    @IBAction func jackpotButtonDidTapped(_ sender: Any) {
        //FIXME: - после этого перехода пропадает Tabbar
        let main = UIStoryboard.init(name: "MyBets", bundle: nil)
        let tabbarVC = main.instantiateViewController(identifier: "MyBetsVC")
        UIApplication.shared.windows.first?.rootViewController = tabbarVC
    }
    private func fetchBet() {
             
        betsRef.observe(.childAdded) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let bet = BetInfoModel()
                bet.setValuesForKeys(dict)
                
                self.friendUsername.text = bet.enemyUsername
                self.awardLabel.text = bet.award
                
                if bet.awardImage != nil {
                    let url = URL(string: bet.awardImage!)
                    self.awardImageView.kf.setImage(with: url)

                }

                
            }
        }
    }
    
}
