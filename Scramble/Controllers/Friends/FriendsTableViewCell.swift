//
//  FriendsTableViewCell.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 25/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    //MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Properties
    
    var user: User?

    
    //MARK: - Helper functions
    
    func update(with user: User) {
        
        self.user = user
        
        nameLabel.text = user.username
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 30
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 1
        
        if user.profileUrl != nil {
            
            let url = URL(string: user.profileUrl!)
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(named: "empty")
        }
    }
    
}
