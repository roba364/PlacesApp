//
//  ConfirmedBetsViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 06/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class PendingBetViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    let currentUser = Auth.auth().currentUser
    let betsRef = Database.database().reference().child("bets")
    var pendingBets = [BetInfoModel]()
    var betRef: DatabaseReference?
    var selectedMatch: BetInfoModel?
    
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
            
            guard
                let self = self,
                let currentUserUID = self.currentUser?.uid
                else { return }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let bet = BetInfoModel()
                bet.setValuesForKeys(dict)
                if bet.isPending && bet.enemyID == currentUserUID ||
                bet.isPending && bet.ownerID == currentUserUID {
                    self.pendingBets.append(bet)
                }
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toBetDetailVC" {
            if let vc = segue.destination as? BetDetailViewController,
                let selectedMatch = selectedMatch {
                //FIXME: - тут как-то хочу передать данные
                
                vc.selectedMatch = selectedMatch
            }
        }
    }
}

extension PendingBetViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pendingBets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PendingBetsTableViewCell else { fatalError() }
        
        let bet = pendingBets[indexPath.row]
        
        cell.update(with: bet)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let match = pendingBets[indexPath.row]
        selectedMatch = match
        
        //FIXME: - вот отсюда перехожу дальше
        
        performSegue(withIdentifier: "toBetDetailVC", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    
    
}
