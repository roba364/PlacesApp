//
//  StorageManager.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 06/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    //MARK: - Save data
    
    static func saveArticle(_ article: News) {
        
        try! realm.write {
            realm.add(article)
        }
    }
    
    static func saveNews(_ news: List<News>) {
        
        try! realm.write {
            realm.add(news)
        }
    }
    
    //MARK: - Delete data
    
    static func deleteArticle(_ article: News) {
        
        try! realm.write {
            realm.delete(article)
        }
    }
    
}
