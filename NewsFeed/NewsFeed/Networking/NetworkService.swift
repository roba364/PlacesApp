//
//  NetworkService.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkService {
    
    var posts = [Model]()
    
    func getFeed(url: String) {
        
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
                
                self.posts.append(Model(author: author, title: title, description: description, url: url, urlToImage: urlToImage, date: date, content: content))
            }
            
            print(self.posts.count)
            
        }.resume()
    }
}
