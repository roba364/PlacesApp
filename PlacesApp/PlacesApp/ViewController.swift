//
//  ViewController.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 25/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var places = ["DEPO", "1067", "Monkeyfood", "Beercap", "VinnieJonhs"]
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }


}

    //MARK: - Extensions

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PlacesTableViewCell else { fatalError() }
        
        cell.placeImageView.image = UIImage(named: places[indexPath.row])
        cell.placeNameLabel.text = places[indexPath.row]
        cell.imageView?.clipsToBounds = true
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }
    
    
    
}

