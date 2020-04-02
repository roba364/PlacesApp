//
//  FriendsTableViewCell.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 21/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class AllUsersTableViewCell: UITableViewCell {
    
    //MARK: - Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var followButton: UIButton!
    
    //MARK: - Properties
    
    var user: User?
    let usersRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)
    
    var friendsAdding: (() -> Void)?
    
    //MARK: - Actions

    @IBAction func followButtonDidTapped(_ sender: Any) {
        
        guard let user = user else { return }
        
        let isFollow = user.isFollowed
        user.isFollowed = !isFollow
        
        friendsAdding?()
        
        refreshFollowButton()
    }
    
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
        
        refreshFollowButton()
    }
    
    private func refreshFollowButton() {
        
        guard let user = user else { return }
        
        user.isFollowed ? followButton.setImage(UIImage(named: "follow2"), for: .normal) : followButton.setImage(UIImage(named: "follow1"), for: .normal)
        
    }
    
    
}
