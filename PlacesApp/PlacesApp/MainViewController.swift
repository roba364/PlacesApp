//
//  ViewController.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 25/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var places: Results<Place>!

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        places = realm.objects(Place.self)
    }
    
    //MARK: - Actions
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? DetailTableViewController else { return }
        
        newPlaceVC.saveNewPlace()
        tableView.reloadData()
    }


}

    //MARK: - Extensions

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return places.isEmpty ? 0 : places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PlacesTableViewCell else { fatalError() }
        
        let place = places[indexPath.row]

        cell.update(with: place)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }
    
    
    
}

