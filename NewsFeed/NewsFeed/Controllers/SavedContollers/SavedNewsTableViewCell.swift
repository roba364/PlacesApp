//
//  SavedNewsTableViewCell.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 07/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Kingfisher

class SavedNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var inCellView: UIView!
    
    func update(article: News) {
        
        guard
            let articleUrlToImage = article.urlToImage else {
                articleImageView.image = UIImage(named: "nophoto")
                return }
        
        let articleImage = URL(string: articleUrlToImage)
        articleImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 20)
        articleImageView.kf.setImage(with: articleImage, options: [.processor(processor)])
        
        
        if let articleDate = article.date {
            dateLabel.text = updateISO8601(toString: articleDate, news: article)
        }

        articleImageView.layer.cornerRadius = 10
        inCellView.layer.cornerRadius = 10
        inCellView.layer.masksToBounds = true

        titleLabel.text = article.title
        
        sourceNameLabel.text = article.sourceName
    }
}
