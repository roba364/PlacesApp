//
//  LocalNewsViewController.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import RealmSwift

class SavedNewsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var savedNews: Results<News> = realm.objects(News.self).filter("isSaved = true")
    
    var selectedArticle: News?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        tableView.reloadData()
        
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailSavedVC" {
            
            let vc = segue.destination as? DetailWorldNewsViewController
            vc?.starButton.tintColor = .clear
            if let article = selectedArticle {
                vc?.article = article
            }
        }
    }
}

    //MARK: - Extensions

extension SavedNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SavedNewsTableViewCell else { fatalError() }
        
        let article = savedNews[indexPath.row]
        
        cell.update(article: article)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let article = savedNews[indexPath.row]
            guard let articleTitle = article.title else { return }
            let predicate = NSPredicate(format: "title == %@", articleTitle)
            let object = realm.objects(News.self).filter(predicate).first
            try! realm.write {
                object?.isSaved = false
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = savedNews[indexPath.row]
        selectedArticle = article
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toDetailSavedVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
}

