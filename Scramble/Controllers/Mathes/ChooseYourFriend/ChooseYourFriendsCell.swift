//
//  ChooseYourFriendsCellViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 03/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Kingfisher

class ChooseYourFriendsCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var usernameImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var moveForwardButton: UIButton!
    
    //MARK: - Properties
    
    var user: User?
    
    //MARK: - Helper functions
    
    func update(with user: User) {
        
        self.user = user
        
        usernameLabel.text = user.username
        usernameImageView.contentMode = .scaleAspectFill
        usernameImageView.layer.cornerRadius = 30
        usernameImageView.layer.borderColor = UIColor.white.cgColor
        usernameImageView.layer.borderWidth = 1
        
        if user.profileUrl != nil {
            
            let url = URL(string: user.profileUrl!)
            usernameImageView.kf.setImage(with: url)
        } else {
            usernameImageView.image = UIImage(named: "empty")
        }
    }
    
}
