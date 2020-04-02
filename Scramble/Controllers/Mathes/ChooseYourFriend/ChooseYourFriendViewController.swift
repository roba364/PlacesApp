//
//  ChooseYourFriendViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 03/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class ChooseYourFriendViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var friends = [User]()
    
    let currentAuthUser = Auth.auth().currentUser
    let usersRef = Database.database().reference().child("users")
    let betsRef = Database.database().reference().child("bets")
    
    var betRef: DatabaseReference?
    
    var selectedUser: User?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchUser()
    }
    
    //MARK: - Helper functions
    
    private func fetchUser() {
        
        guard let currentAuthUser = currentAuthUser else { return }
        
        let currentUser = usersRef.child(currentAuthUser.uid)
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
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAwardSeg" {
            if let vc = segue.destination as? ChooseYourAward {
                vc.betRef = betRef
            }
        }
    }
}

extension ChooseYourFriendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChooseYourFriendsCell else { fatalError() }
        
        let friend = friends[indexPath.row]
        
        cell.update(with: friend)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let friend = friends[indexPath.row]
        selectedUser = friend
        
        let values = ["enemyID": selectedUser?.id, "enemyUsername": selectedUser?.username]
        
        betRef?.updateChildValues(values as [AnyHashable : Any])
        performSegue(withIdentifier: "toAwardSeg", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
}
