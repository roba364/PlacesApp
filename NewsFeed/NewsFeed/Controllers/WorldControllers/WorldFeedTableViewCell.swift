//
//  WorldFeedTableViewCell.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Kingfisher

class WorldFeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func update(article: News) {
        
        guard let urlImage = article.urlToImage else { return }
        
        if let articleImage = URL(string: urlImage) {
            articleImageView.kf.setImage(with: articleImage)
        }
        
        titleLabel.text = article.title
        dateLabel.text = article.date
    }
}
