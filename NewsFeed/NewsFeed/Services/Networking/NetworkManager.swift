//
//  NetworkService.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetworkManager {
    
    var posts = [News]()
    
    func getFeed(url: String, completion: @escaping ([News]) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard
                let data = data,
                let self = self
                else { return }
            
            let json = try! JSON(data: data)
            
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
                self.posts.append(News(author: author, title: title, desc: description, url: url, urlToImage: urlToImage, date: date, content: content, sourceID: sourceID, sourceName: sourceName))
                
                DispatchQueue.main.async {
                    completion(self.posts)
                }
            }
            
        }.resume()
    }
}
