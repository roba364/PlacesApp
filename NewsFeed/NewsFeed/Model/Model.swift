//
//  Model.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation

struct Model: Codable {
    
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var date: String
    var content: String

}
