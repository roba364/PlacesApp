//
//  WorldNewsViewController.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 03/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import UIKit

class WorldNewsViewController: UIViewController {
    
    var networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()

        networkService.getFeed(url: WORLDWIDE_URL)
    }


}
