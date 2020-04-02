//
//  FriendsViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 25/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class FriendsViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var friends = [User]()
    
    let currentAuthUser = Auth.auth().currentUser
    let ref = Database.database().reference().child("users")
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        fetchUser()
    }
    
    //MARK: - Helper functions
    
    private func fetchUser() {
        
        guard let currentAuthUser = currentAuthUser else { return }
        
        let currentUser = ref.child(currentAuthUser.uid)
                             .child("friends")
        
        currentUser.observe(.childAdded) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dict)
                self.friends.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            
        }
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? FriendsTableViewCell else { fatalError() }
        
        let friend = friends[indexPath.row]
        
        cell.update(with: friend)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            guard let userIDToDelete = friends[indexPath.row].id,
                let currentUserUID = currentAuthUser?.uid
                else { return }

            friends.remove(at: indexPath.row)
            
            ref.child(currentUserUID).child("friends").child(userIDToDelete).removeValue()
            
            tableView.reloadData()
        }
    }
    
    
}
