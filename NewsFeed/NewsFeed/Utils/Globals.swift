//
//  Globals.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation

let WORLDWIDE_URL = "http://newsapi.org/v2/top-headlines?" +
"country=ru&" +
"apiKey=10c73e7bd7c24dd2a1062a0c697ad1d5"


func updateISO8601(toString article: String, news: News) -> String {
    
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    guard let articleDate = news.date,
          let date = formatter.date(from: articleDate)
        else { return "" }
    
    formatter.timeZone = .current
    formatter.dateStyle = .medium
    formatter.locale = .current
    
    return formatter.string(from: date)
}

