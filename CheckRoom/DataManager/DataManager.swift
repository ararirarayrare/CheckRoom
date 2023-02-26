//
//  DataManager.swift
//  CheckRoom
//
//  Created by mac on 06.02.2023.
//

import UIKit
import RealmSwift

class DataManager {
    
    //    var outfitForTomorrow: Outfit? {
    //        get {
    //            let standard = UserDefaults.standard
    //
    //            if let keyDate = (standard.dictionary(forKey: "tomorrowOutfit") as? [String : Date])?.first,
    //               let outfit = realm.object(ofType: Outfit.self, forPrimaryKey: keyDate.key),
    //               keyDate.value > Date() {
    //
    //                return outfit
    //
    //            }
    //            return nil
    //        }
    //
    //        set {
    //            guard let key = newValue?.key,
    //                  let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) else {
    //                return
    //            }
    //
    //            let tomorrowMidnight = Calendar.current.startOfDay(for: tomorrowDate)
    //
    //            UserDefaults.standard.set([key : tomorrowMidnight], forKey: "tomorrowOutfit")
    //        }
    //    }
    //
    //    var outfitForToday: Outfit? {
    //        get {
    //            nil
    //        }
    //    }
    
    func tomorrowOutfit() -> Outfit? {
        let standard = UserDefaults.standard
        
        if let keyDate = (standard.dictionary(forKey: "tomorrowOutfit") as? [String : Date])?.first,
           keyDate.value > Date() {
            
            realm?.beginWrite()
            let outfit = realm.objects(Outfit.self).first(where: { $0.key == keyDate.key })
            try? realm?.commitWrite()
            
            return outfit
        }
        
        return nil
    }
    
    func savedOutfits() -> [Date : Outfit]? {
        
        if let data = UserDefaults.standard.data(forKey: "savedOutfits"),
           let dateKeys = try? JSONDecoder().decode([Date : String].self, from: data) {
            
            let dateOutfits = dateKeys.compactMapValues { key in
                realm?.beginWrite()
                let outfit = realm?.objects(Outfit.self).first(where: { $0.key == key })
                try? realm.commitWrite()
                return outfit
            }
            
            return dateOutfits
            
        }
        
        return nil
    }
    
    func setTomorrowOutfit(_ outfit: Outfit) {
        
        let defaults = UserDefaults.standard
        
        if let savedOutfitsData = defaults.data(forKey: "savedOutfits"),
           var savedOutfits = try? JSONDecoder().decode([Date : String].self, from: savedOutfitsData),
           let outfitKey = outfit.key {
            
            if let tomorrowDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) {
                savedOutfits.updateValue(outfitKey, forKey: tomorrowDate)
            }
            
            // MARK: - keep 2 objects in dict, should work with midnight dates.
            
            fatalError("CHECK COMMENT!")
            
            if let data = try? JSONEncoder().encode(savedOutfits) {
                defaults.set(data, forKey: "savedOutfits")
            }
            
        } else {
            
            if let outfitKey = outfit.key,
               let tomorrowDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) {
                
//                let tomorrowMidnight = Calendar.current.startOfDay(for: tomorrowDate)
                
                if let data = try? JSONEncoder().encode([tomorrowDate : outfitKey]) {
                    defaults.set(data, forKey: "savedOutfits")
                }
                
            }
            
        }
        
    }
    
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
        //            .compactMap { $0 as? T }
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
