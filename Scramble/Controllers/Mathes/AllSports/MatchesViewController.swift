//
//  MatchesViewController.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 14/02/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class MatchesViewController: UITableViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var leaguesImageView: UIImageView!
    @IBOutlet weak var sportLabel: UILabel!
    
    let allMatches = AllMatches()
    
    //MARK: - Lifecycle
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("THE SELECTED SECTION IS : \(indexPath.section)")
        
    }
 
}

