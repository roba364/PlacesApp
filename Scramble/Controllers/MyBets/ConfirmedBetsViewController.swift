//
//  ConfirmedBetsViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 08/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class ConfirmedBetsViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    let currentUser = Auth.auth().currentUser
    let betsRef = Database.database().reference().child("bets")
    var confirmedBets = [BetInfoModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchConfirmedBets()
    }
    
    private func fetchConfirmedBets() {
               
        betsRef.observe(.childAdded) { [weak self] (snapshot) in
            
            guard
                let self = self,
                let currentUserUID = self.currentUser?.uid
            else { return }
        
            if let dict = snapshot.value as? [String: AnyObject] {
                let bet = BetInfoModel()
                bet.setValuesForKeys(dict)
                if bet.isConfirmed && bet.ownerID == currentUserUID ||
                bet.isConfirmed && bet.enemyID == currentUserUID {
                        self.confirmedBets.append(bet)
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}

    //MARK: - Extensions

extension ConfirmedBetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return confirmedBets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ConfirmedBetsTableViewCell else { fatalError() }
        
        let bet = confirmedBets[indexPath.row]
        
        cell.update(with: bet)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
}
