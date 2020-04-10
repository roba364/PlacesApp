//
//  NetworkService.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class NetworkManager {
    
    func getFeed(url: String, completion: @escaping () -> ()) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let data = data
                else { return }
            
            let json = try! JSON(data: data)
            
            let posts = List<News>()
            
            for i in json["articles"] {
                
                let author = i.1["author"].stringValue
                let title = i.1["title"].stringValue
                let description = i.1["description"].stringValue
                let url = i.1["url"].stringValue
                let urlToImage = i.1["urlToImage"].stringValue
                let date = i.1["publishedAt"].stringValue
                let content = i.1["content"].stringValue
                let sourceID = i.1["source"]["id"].stringValue
                let sourceName = i.1["source"]["name"].stringValue
                
                DispatchQueue.main.sync {
                    
                    let predicate = NSPredicate(format: "title = %@", title)
                    let results = realm.objects(News.self).filter(predicate)
                    
                    if results.isEmpty {
                        posts.insert(News(author: author, title: title, desc: description, url: url, urlToImage: urlToImage, date: date, content: content, sourceID: sourceID, sourceName: sourceName), at: 0)
                        StorageManager.saveNews(posts)
                        completion()
                    } else {
                        for result in results {
                            
                            if result.title != title {
                                posts.insert(News(author: author, title: title, desc: description, url: url, urlToImage: urlToImage, date: date, content: content, sourceID: sourceID, sourceName: sourceName), at: 0)
                                StorageManager.saveNews(posts)
                                completion()
                            }
                        }
                    }
                    //                    StorageManager.saveNews(posts)
                }
            }
        }.resume()
    }
}
