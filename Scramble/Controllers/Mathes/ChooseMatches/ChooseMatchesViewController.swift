//
//  ChooseMatchesViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 18/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class ChooseMatchesViewController: UIViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    let currentUser = Auth.auth().currentUser
    
    let matchesRef = Database.database().reference().child("matches")
    let betsRef = Database.database().reference().child("bets")
    
    var newBetRef: DatabaseReference?
    var allMatches = AllMatches()
    
    var choose = ChooseMatchesTableViewCell()
    var allMatchesArray : [AllMatches] = []
    
    var selectedMatch: AllMatches?
    
    
    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAllMatches()

    }
    
    //MARK: - Selectors
    
    // MARK: - Firebase data
    
    private func fetchAllMatches() {
        
        matchesRef.observe(.childAdded) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let allMatches = AllMatches()
                allMatches.setValuesForKeys(dict)
                self.allMatchesArray.append(allMatches)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "selectedMatch" {
            if let vc = segue.destination as? MakeYourBetViewController,
                let goBet = selectedMatch {
                vc.allMatches = goBet
                vc.betRef = newBetRef
            }
        }
    }
    
    //MARK: - Helper functions
    
    func createBet(match: AllMatches) {
           
           guard let currentUserUID = currentUser?.uid else { return }
           
           self.newBetRef = betsRef.childByAutoId()
           
           matchesRef.observe(.childAdded) { (snapshot) in
            
            let values: [String: Any] = ["date": match.date as Any,
                                         "matchStatus": match.matchStatus as Any,
                                         "status": "pending",
                                         "team1": match.team1 as Any,
                                         "team1logo": match.team1logo as Any,
                                         "team2": match.team2 as Any,
                                         "team2logo": match.team2logo as Any,
                                         "ownerID": currentUserUID,
                                         "matchID": "\(String(describing: self.newBetRef))"
                                        ]
    
               self.newBetRef?.setValue(values) { [weak self] (error, databaseRef) in
                                                   
                   guard let self = self else { return }
                   
                   if let error = error {
                       print("Data could not be saved: \(error).")
                   } else {
                       print("Data saved successfully!")
                       self.selectedMatch = match
                    
                    //FIXME: - почемуто после того как ты написал эту функцию - стал 2 раза выезжать VC
                    
                       self.performSegue(withIdentifier: "selectedMatch", sender: nil)
                   }
               }
               
           }
           
       }

    
}

    //MARK: - Extensions

extension ChooseMatchesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMatchesArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard currentUser?.uid != nil else { return }
        
        let match = allMatchesArray[indexPath.row]
        createBet(match: match)
        

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChooseMatchesTableViewCell
        
        let allMatches = allMatchesArray[indexPath.row]
        
        cell.update(with: allMatches)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    
    
    
}
