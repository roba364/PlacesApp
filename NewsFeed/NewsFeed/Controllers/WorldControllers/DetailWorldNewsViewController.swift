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
        
        let predicate = NSPredicate(format: "title = %@", article.title!)
        let result = realm.objects(News.self).filter(predicate)
        
        if result.count > 0 {
            starButton.image = UIImage(named: "filledStar")
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
        checkSavedArticleAndSetupStar()
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
    
    private func checkSavedArticleAndSetupStar() {
        
        guard let articleTitle = article.title else { return }
        
        let predicate = NSPredicate(format: "title = %@", articleTitle)
        let result = realm.objects(News.self).filter(predicate)
        
        if result.count > 0 {
            starButton.image = UIImage(named: "filledStar")
        }
    }
    
    //MARK: - Actions
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let article = article else { return }
        
        starButton.image = UIImage(named: "filledStar")
        article.isSaved = true
        StorageManager.saveArticle(article)
        
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
