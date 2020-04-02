//
//  ProfileViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 14/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: - Properties
    
    let usersRef = Database.database().reference().child("users")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setupUI
        setupAvatar()
        
        fetchCurrentUser()
    }
    
    //MARK: - Actions
    
    @IBAction func logOutButtonTapped(_ sender: UIBarButtonItem) {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            dismiss(animated: true, completion: nil)
            
        } catch let signOutError {
            print("Sign out error :", signOutError)
        }
        let main = UIStoryboard.init(name: "Main", bundle: nil)
        let loginVC = main.instantiateViewController(identifier: "navLoginVC")
        UIApplication.shared.windows.first?.rootViewController = loginVC
    }
    
    //MARK: - Setup UI
    
    private func setupAvatar() {
        
        profileImageView.layer.cornerRadius = 50
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
    }
    
    //MARK: - Helper functions
    
    private func fetchCurrentUser() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        usersRef.child(uid).observe(.value) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if let dict = snapshot.value as? [String: AnyObject] {
                    let profileUrl = dict["profileUrl"] as? String
                    
                    self.profileImageView.kf.setImage(with: URL(string: profileUrl ?? ""))
                    self.nameLabel.text = dict["username"] as? String
                }
            }
            
        }
    }
    
    
}
