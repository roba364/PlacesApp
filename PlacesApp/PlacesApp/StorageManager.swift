//
//  StorageManager.swift
//  PlacesApp
//
//  Created by SofiaBuslavskaya on 26/03/2020.
//  Copyright © 2020 Sergey Borovkov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        
        try! realm.write {
            realm.add(place)
        }
    }
}
