//
//  DataManager.swift
//  CheckRoom
//
//  Created by mac on 06.02.2023.
//

import UIKit
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    
    private let realm: Realm! = try! Realm()
    
    func save(wear: Wear) {
        try! realm.write {
            self.realm?.add(wear)
        }
    }
    
    func getWear<T: Wear>(type: T.Type, forSeason season: Season) -> [T] {
        realm?.beginWrite()
        let objects = realm?.objects(type)
        try? realm?.commitWrite()
        
        var array = [T]()
        objects?.filter { $0.season == season }
            .forEach { array.append($0) }

        return array
    }
}
