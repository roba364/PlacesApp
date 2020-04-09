//
//  WorldNewsViewController.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit
import RealmSwift

class WorldNewsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var networkManager = NetworkManager()
    var refreshControl: UIRefreshControl!
    
    var savedNews = realm.objects(News.self)
    var news = List<News>()
    var selectedArticle: News?
    
    var checkConnectionTimer: Timer?
    var newsFeedTimer: Timer?
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupRefreshControl()
        getNewsFeed()
        
        checkConnectionTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkInternetConnectionAfter5), userInfo: nil, repeats: true)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
        if savedNews.count > 0 {
            
        }
    }
    
    //MARK: - Setup UI
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshByPull), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    //MARK: - Actions
    
    @objc func checkInternetConnectionAfter5() {
        
        if Connectivity.isConnectedToInternet {
            
            print("connected")
            cancelTimer()
        } else {
            print("no connected")
            
            newsFeedTimer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(getNewsFeed), userInfo: nil, repeats: false)
            
        }
    }
    
    @objc func refreshByPull(_ sender: Any) {

        getNewsFeed()

        refreshControl.endRefreshing()
    }
    
    //MARK: - Timer
    
    private func cancelTimer() {
      newsFeedTimer?.invalidate()
      newsFeedTimer = nil
    }
    
    //MARK: - Download data
    
    @objc private func getNewsFeed() {
        
        networkManager.getFeed(url: WORLDWIDE_URL) { [weak self] (news) in
            
            guard let self = self else { return }
            
            self.news = news
            self.tableView.reloadData()

            print("got feed")
        }
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
        
        return savedNews.count != 0 ? savedNews.count : news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? WorldFeedTableViewCell else { fatalError() }
        
        if savedNews.count != 0 {
            let savedArticle = savedNews[indexPath.row]
            cell.update(article: savedArticle)
        } else {
            let article = news[indexPath.row]
            cell.update(article: article)
        }
        
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


