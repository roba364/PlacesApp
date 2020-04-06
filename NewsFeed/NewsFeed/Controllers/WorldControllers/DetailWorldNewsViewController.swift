//
//  DetailWorldNewsViewController.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import Kingfisher

class DetailWorldNewsViewController: UIViewController {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var urlLabel: UILabel!
    
    //MARK: - Properties
    
    var article: News!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        let urlImage = URL(string: article.urlToImage!)
        articleImageView.kf.setImage(with: urlImage)
        
        sourceNameLabel.text = article.sourceName
        dateLabel.text = article.date
        titleLabel.text = article.title
        descriptionTextView.text = article.description
        urlLabel.text = article.url
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnURL(sender:)))
        urlLabel.isUserInteractionEnabled = true
        urlLabel.addGestureRecognizer(tap)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        guard let articleDate = article.date,
              let date = formatter.date(from: articleDate)
            else { return }
        
        formatter.timeZone = .current
        formatter.dateStyle = .medium
        formatter.locale = .current
        
        dateLabel.text = formatter.string(from: date)
    }
    
    //MARK: - Actions
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        
        let activityController = UIActivityViewController(activityItems: [article.url!], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
    }
    
    @objc func tapOnURL(sender: UITapGestureRecognizer) {
        guard
            let urlString = self.urlLabel.text,
            let url = URL(string: urlString)
            else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

    }
}
