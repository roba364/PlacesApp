//
//  BetInfoModel.swift
//  Scramble
//
//  Created by SofiaBuslavskaya on 05/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import Foundation
import Firebase

class BetInfoModel: NSObject {
    
    @objc var ownerResult: String?
    @objc var enemyResult: String?
    @objc var ownerID: String?
    @objc var team1: String?
    @objc var team2: String?
    @objc var date: String?
    @objc var matchStatus: String?
    @objc var status: String?
    @objc var award: String?
    @objc var awardImage: String?
    @objc var team1logo: String?
    @objc var team2logo: String?
    @objc var result: String?
    @objc var enemyID: String?
    @objc var enemyUsername: String?
    @objc var matchID: String?

    struct Constants {
        static let pendingStatus = "pending"
        static let confirmedStatus = "confirmed"
    }

    
}

extension BetInfoModel {
    
    var isPending: Bool {
        status == Constants.pendingStatus
    }
    
    var isConfirmed: Bool {
        status == Constants.confirmedStatus
    }
    
}
