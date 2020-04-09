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
    @IBOutlet weak var inCellView: UIView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    
    func update(article: News) {
        
        guard
            let urlImage = article.urlToImage
            else { articleImageView.image = UIImage(named: "nophoto")
                return }
            
        
        if let articleImage = URL(string: urlImage) {
            articleImageView.kf.indicatorType = .activity
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            articleImageView.kf.setImage(with: articleImage, options: [.processor(processor)])
        }
        
        if let articleDate = article.date {
            dateLabel.text = updateISO8601(toString: articleDate, news: article)
        }
        
        articleImageView.layer.cornerRadius = 10
        inCellView.layer.cornerRadius = 10
        inCellView.layer.masksToBounds = true
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.text = article.title
        
        sourceNameLabel.text = article.sourceName
    }
}
