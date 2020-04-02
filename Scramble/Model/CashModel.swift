//
//  CashModel.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 03/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import UIKit

struct Cash {
    
    var mainImage: UIImage
    var coins: Int
    
    static func fetchCash() -> [Cash] {
        
        var cash = [Cash]()
        
        let five = Cash(mainImage: UIImage(named: "bitcoin")!, coins: 5)
        let ten = Cash(mainImage: UIImage(named: "ruble")!, coins: 10)
        let twenty = Cash(mainImage: UIImage(named: "pound")!, coins: 20)
        let fifty = Cash(mainImage: UIImage(named: "yuan")!, coins: 50)
//        let hundred = Cash(mainImage: UIImage(named: ""))
//        let twoHundred = Cash(mainImage: UIImage(named: ""))
//        let threeHundred = Cash(mainImage: UIImage(named: ""))
//        let fiveHundred = Cash(mainImage: UIImage(named: ""))
//        let thousand = Cash(mainImage: UIImage(named: ""))
//
        cash.append(five)
        cash.append(ten)
        cash.append(twenty)
        cash.append(fifty)
//        cash.append(hundred)
//        cash.append(twoHundred)
//        cash.append(threeHundred)
//        cash.append(fiveHundred)
//        cash.append(contentsOf: thousand)
//
        return cash
        
    }
}

struct Constants {
    
    static let leftDistanceToSuperView: CGFloat = 10
    static let rightDistanceToSuperView: CGFloat = 10
    static let galleryMinimumLineSpacing: CGFloat = 10
    static let galleryItemWidth = (UIScreen.main.bounds.width - Constants.leftDistanceToSuperView - Constants.rightDistanceToSuperView - (Constants.galleryMinimumLineSpacing / 4)) / 4
}
