//
//  DetailWorldNewsViewController.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class DetailWorldNewsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var starButton: UIBarButtonItem!
    
    //MARK: - Properties
    
    var article: News!
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let results = realm.objects(News.self).filter("isSaved = true")
        
        for result in results {
            if result.title == article.title {
                starButton.image = UIImage(named: "filledStar")
            } else {
                starButton.image = UIImage(named: "emptyStar")
            }
        }
        
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        guard
            let articleUrlToImage = article.urlToImage else {
                articleImageView.image = UIImage(named: "nophoto")
                return }
        
        if let articleImage = URL(string: articleUrlToImage) {
            articleImageView.kf.indicatorType = .activity
            let processor = RoundCornerImageProcessor(cornerRadius: 20)
            articleImageView.kf.setImage(with: articleImage, options: [.processor(processor)])
        }
        
        sourceNameLabel.text = article.sourceName
        dateLabel.text = article.date
        titleLabel.text = article.title
        descriptionTextView.text = article.desc
        urlLabel.text = article.url
        
        setupDateEUFormat()
        setupTapGesture()

    }
    
    private func setupTapGesture() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapOnURL(sender:)))
        urlLabel.isUserInteractionEnabled = true
        urlLabel.addGestureRecognizer(tap)   
    }
    
    func setupDateEUFormat() {
        
        guard let articleDate = article.date else { return }
        
        dateLabel.text = updateISO8601(toString: articleDate, news: article)
    }
    
    //MARK: - Check articles
    
    
    //MARK: - Actions
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let article = article else { return }
        
        starButton.image = UIImage(named: "filledStar")
        DispatchQueue.main.async {
                
            if let articleTitle = article.title {
                let predicate = NSPredicate(format: "title == %@", articleTitle)
                let article = realm.objects(News.self).filter(predicate).first
                try! realm.write {
                    article?.isSaved = true
                }
            }
        }
    }
    
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
    
    //MARK: - Helper functions
    
    
}
