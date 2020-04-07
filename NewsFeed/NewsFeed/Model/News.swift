//
//  Model.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import RealmSwift

class News: Object, Codable {
    
    @objc dynamic var author: String?
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var url: String?
    @objc dynamic var urlToImage: String?
    @objc dynamic var date: String?
    @objc dynamic var content: String?
    @objc dynamic var sourceID: String?
    @objc dynamic var sourceName: String?
    @objc dynamic var isSaved = false
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case desc = "description"
        case url
        case urlToImage
        case date
        case content
        case sourceID
        case sourceName
    }
    
    init(author: String?, title: String?, desc: String?, url: String?, urlToImage: String?,
         date: String?, content: String?, sourceID: String?, sourceName: String?) {
        
        self.author = author
        self.title = title
        self.desc = desc
        self.url = url
        self.urlToImage = urlToImage
        self.date = date
        self.content = content
        self.sourceID = sourceID
        self.sourceName = sourceName
    }
    
    required init() {
        super.init()
    }
    
}
