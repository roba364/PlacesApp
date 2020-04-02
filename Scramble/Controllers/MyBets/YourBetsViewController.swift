//
//  PendingBetsViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 06/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class YourBetsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    let currentUser = Auth.auth().currentUser
    let betsRef = Database.database().reference().child("bets")
    var ownerPendingBets = [BetInfoModel]()
    
    //MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchPendingBets()
    }
    
    //MARK: - Helper functions
    
    private func fetchPendingBets() {
               
        betsRef.observe(.childAdded) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let bet = BetInfoModel()
                bet.setValuesForKeys(dict)
                if bet.isPending && bet.ownerID == self.currentUser?.uid {
                        self.ownerPendingBets.append(bet)
                }
                
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
}

    //MARK: - Extensions

extension YourBetsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ownerPendingBets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? YourBetsTableViewCell else { fatalError() }
        
        let bet = ownerPendingBets[indexPath.row]
        
        cell.update(with: bet)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    
    
}
