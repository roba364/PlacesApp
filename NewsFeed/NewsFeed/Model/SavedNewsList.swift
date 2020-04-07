//
//  SavedNewsList.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 06/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import RealmSwift

class SavedNewsList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    
    let news = List<News>()
}

