//
//  DataManager.swift
//  CheckRoom
//
//  Created by mac on 06.02.2023.
//

import UIKit
import RealmSwift

class DataManager {
    
    private let realm: Realm? = try? Realm()
    
    func save(wear: Wear) {
        realm?.beginWrite()
        realm?.add(wear)
        try? realm?.commitWrite()
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
