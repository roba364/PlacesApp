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
    var refreshControl: UIRefreshControl!
    
    var news = [News]()
    var selectedArticle: News?
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)

        networkManager.getFeed(url: WORLDWIDE_URL) { (news) in
            
            self.news = news
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Actions
    
    @objc func refresh(_ sender: Any) {
        
        networkManager.getFeed(url: WORLDWIDE_URL) { (news) in
            
            self.news = news
            self.tableView.reloadData()
        }
        
        refreshControl.endRefreshing()
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toDetailWorldVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
}


