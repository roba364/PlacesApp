//
//  ChooseYourBetViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 03/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Firebase

class ChooseYourAward: UIViewController {
    
    @IBOutlet weak var depositCashLabel: UILabel!
    @IBOutlet weak var otherBetsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    private var galleryCollectionView = GalleryCollectionView()
    var selectedAward: Award?
    let currentUser = Auth.auth().currentUser
    let betsRef = Database.database().reference().child("bets")
    let awardsRef = Database.database().reference().child("awards").child("award")
    var awards = [Award]()
    var betRef: DatabaseReference?

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        fetchCash()
        fetchAwards()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchCash() {
        
        galleryCollectionView.update(cells: Cash.fetchCash())
    }
    
    private func fetchAwards() {
        
        awardsRef.observe(.childAdded) { [weak self] (snapshot) in
            
            guard let self = self else { return }
            
            if let dict = snapshot.value as? [String: AnyObject] {
                let award = Award()
                award.setValuesForKeys(dict)
                self.awards.append(award)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    private func setupConstraints() {
        
        view.addSubview(galleryCollectionView)

        
        galleryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        galleryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        galleryCollectionView.topAnchor.constraint(equalTo: depositCashLabel.bottomAnchor, constant: 0).isActive = true
        
        galleryCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true

    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAwardSeg" {
            if let vc = segue.destination as? BetInfoViewController {
                vc.betRef = betRef
            }
        }
    }
}

    //MARK: - Extension

extension ChooseYourAward: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return awards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ChooseYourAwardTableViewCell else { fatalError() }
        
        let award = awards[indexPath.row]
        
        cell.update(with: award)
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let award = awards[indexPath.row]
        selectedAward = award
        
        // FIXME: - add logic
        
        guard let selectedAwardName = self.selectedAward?.name,
              let selectedAwardUrl = self.selectedAward?.imageUrl
            else { return }
        
        let values = ["award": selectedAwardName,
                      "awardImage": selectedAwardUrl]
        
        self.betRef?.updateChildValues(values)
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toConfirmYourBet", sender: nil)
    }
}
