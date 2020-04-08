//
//  ConnectManager.swift
//  NewsFeed
//
//  Created by SofiaBuslavskaya on 08/04/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Alamofire
import UIKit

struct Connectivity {
    
  static let sharedInstance = NetworkReachabilityManager()
    
  static var isConnectedToInternet:Bool {
    
    return self.sharedInstance?.isReachable ?? false
    }
}



