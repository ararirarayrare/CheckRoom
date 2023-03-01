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
    
    var isNewUser: Bool {
        return !UserDefaults.standard.bool(forKey: .hasSeenOnboardingKey)
    }
    
    func userHasSeenOnboarding() {
        UserDefaults.standard.set(true, forKey: .hasSeenOnboardingKey)
    }
    
    func containsOutfit(_ outfit: Outfit) -> Bool {
        let outfits = getOutfits(forSeason: outfit.season)
        
        return outfits.contains(where: { outfit.isEqual(toOutfit: $0) })
    }
    
    
    func save(wear: Wear) {
        try? realm.write {
            self.realm?.add(wear)
        }
    }
    
    func getWear<T: Wear>(type: T.Type, forSeason season: Season) -> [T] {
        realm?.beginWrite()
        let objects = realm?.objects(type)
        try? realm?.commitWrite()
        
        var array = [T]()
        objects?.filter { $0.season == season }
            .forEach { object in
                if !array.contains(where: { wear in wear.isEqual(toWear: object) }) {
                    array.append(object)
                }
            }
        
        return array
    }
    
    func deleteWear(_ wear: Wear) {
        try? realm?.write { self.realm?.delete(wear) }
    }
    
    func save(outfit: Outfit) {
        try? realm.write {
            self.realm?.add(outfit)
        }
    }
    
    func getOutfits(forSeason season: Season) -> [Outfit] {
        realm?.beginWrite()
        let objects = realm?.objects(Outfit.self)
        try? realm?.commitWrite()
        
        var array = Array<Outfit>()
        
        objects?.filter { $0.season == season }
            .forEach { array.append($0) }
        
        return array
    }
    
    func updateOutfit(_ updateHandler: () -> Void) {
        try? realm.write { updateHandler() }
    }
    
    func deleteOutfit(_ outfit: Outfit) {
        try? realm.write { self.realm.delete(outfit) }
    }
    
    func savedOutfits() -> [Date : Outfit]? {
        
        if let data = UserDefaults.standard.data(forKey: "savedOutfits"),
           let dateKeys = try? JSONDecoder().decode([Date : String].self, from: data) {
            
            let datesRange: ClosedRange<Date> = (.todayMidnight)...(.tomorrowMidnight)
            
            let dateOutfits = dateKeys.compactMapValues { key in
                realm?.beginWrite()
                let outfit = realm?.objects(Outfit.self).first(where: { $0.key == key })
                
            
                try? realm.commitWrite()
                return outfit
            }.filter { datesRange.contains($0.key) }

            return dateOutfits
            
        }
        
        return nil
    }
    
    func setTomorrowOutfit(_ outfit: Outfit) {
        
        let defaults = UserDefaults.standard
        
        if let savedOutfitsData = defaults.data(forKey: "savedOutfits"),
           let savedOutfits = try? JSONDecoder().decode([Date : String].self, from: savedOutfitsData),
           let outfitKey = outfit.key {
            
            let datesRange: ClosedRange<Date> = (.todayMidnight)...(Date())
            
            var filteredOutfits = savedOutfits.filter({ datesRange.contains($0.key) })
            filteredOutfits.updateValue(outfitKey, forKey: Date.tomorrowMidnight)
            
                        
            if let data = try? JSONEncoder().encode(filteredOutfits) {
                defaults.set(data, forKey: "savedOutfits")
            }
            
        } else {
            
            if let outfitKey = outfit.key,
               let data = try? JSONEncoder().encode([Date.tomorrowMidnight : outfitKey]) {
                
                defaults.set(data, forKey: "savedOutfits")
                
            }
            
        }
        
    }
}

extension String {
    static let hasSeenOnboardingKey = "hasSeenOnboardingKey"
}
