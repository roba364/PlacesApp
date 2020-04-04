//
//  WorldNewsViewController.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class WorldNewsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var networkManager = NetworkManager()
    
    var news = [News]()
    var selectedArticle: News?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        networkManager.getFeed(url: WORLDWIDE_URL) { (news) in
            
            self.news = news
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDetailWorldVC" {
            
            let vc = segue.destination as? DetailWorldNewsViewController
            
            if let article = selectedArticle {
                vc?.article = article
            }
        }
    }
    
}

    //MARK: - Extension

extension WorldNewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WorldFeedTableViewCell else { fatalError() }
        
        let article = news[indexPath.row]
        
        cell.update(article: article)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = news[indexPath.row]
        selectedArticle = article
        
        performSegue(withIdentifier: "toDetailWorldVC", sender: nil)
    }
}


