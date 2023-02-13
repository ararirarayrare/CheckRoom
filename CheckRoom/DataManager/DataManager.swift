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
    
    func contains(_ object: Object) -> Bool {
        realm.beginWrite()
        defer {
            try! realm.commitWrite()
        }
        
        return realm.objects(type(of: object)).contains(where: { $0 == object })
    }
    
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
    
    func save(outfit: Outfit) {
        try! realm.write {
            self.realm?.add(outfit)
        }
    }
    
    func getOutfits(forSeason season: Season) -> [Outfit] {
        realm?.beginWrite()
        let objects = realm?.objects(Outfit.self)
        try! realm?.commitWrite()
        
        var array = Array<Outfit>()
        
        objects?.filter { $0.season == season }
            .forEach { array.append($0) }
        
        return array
    }
    
    func updateOutfit(_ updateHandler: () -> Void) {
        
        try! realm.write({ updateHandler() })
        
    }
}
