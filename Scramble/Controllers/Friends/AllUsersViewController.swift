//
//  FriendsViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 14/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase
import Alamofire


class AllUsersViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!

    //MARK: - Properties
    
    let authUser = Auth.auth().currentUser
    
    let usersRef = Database.database().reference().child("users")
    var allUsers = [User]()
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        fetchUser()
    }
    
    //MARK: - Helper functions
    
    private func fetchUser() {
        
        usersRef.observe(.childAdded) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dict)
                self.allUsers.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
}

extension AllUsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AllUsersTableViewCell else { fatalError() }
        
        let user = allUsers[indexPath.row]
        
        cell.update(with: user)
        cell.friendsAdding = { [weak self] in
            
            guard let self = self else { return }
            
            self.usersRef.child(self.authUser!.uid).child("friends").child(cell.user!.id!).setValue(["username": cell.user?.username, "profileUrl" : cell.user?.profileUrl, "email": cell.user?.email, "id" : cell.user?.id]) {
                (error, ref) in
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}

