//
//  SavedNewsTableViewCell.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 07/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class SavedNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func update(cell: News) {
        
        label.text = cell.sourceName
    }
}
