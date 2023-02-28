//
//  Wear.swift
//  CheckRoom
//
//  Created by mac on 31.01.2023.
//

import UIKit
import RealmSwift

extension Season: PersistableEnum {}

class Wear: Object {
        
    fileprivate var lock = pthread_rwlock_t()
    private var lockAttributes = pthread_rwlockattr_t()
    
    fileprivate(set) var image: UIImage? {
        get {
            return UIImage(data: imageData)
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            if let data = newValue?.pngData() {
                imageData = data
            }
            pthread_rwlock_unlock(&lock)
        }
    }
    
    @objc dynamic private var imageData: Data = Data()
    
    @objc dynamic private var seasonRawValue: String = ""
    
    var season: Season! {
        get {
            guard let rawValue = Int(seasonRawValue), let season = Season(rawValue: rawValue) else {
                return nil
            }
            return season
        }

        set {
            pthread_rwlock_wrlock(&lock)
            seasonRawValue = String(describing: newValue.rawValue)
            pthread_rwlock_unlock(&lock)
        }
    }
    
    fileprivate func setup() {
        pthread_rwlock_init(&lock, &lockAttributes)
    }
    
    @objc dynamic fileprivate(set) var key: String! = ""
    
    override init() {
        super.init()
        
        self.key = .randomString(length: 64)
    }
    
    func isEqual(toWear wear: Wear?) -> Bool {
        return (self.key == wear?.key && self.season == wear?.season && self.image?.pngData() == wear?.image?.pngData())
    }
}

class TopWear: Wear {
    
    func getCopy() -> TopWear {
        let copy = TopWear(image: self.image, category: self.category)
        if let season = self.season { copy.season = season }
        copy.key = key
        return copy
    }
    
    enum Category: Int {
        case outwear = 0
        case undercoat = 1
    }
    
    @objc dynamic private var categoryRawValue: String = ""
    
    private(set) var category: Category {
        get {
            return Category(rawValue: Int(categoryRawValue)! )!
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            categoryRawValue = String(describing: newValue.rawValue)
            pthread_rwlock_unlock(&lock)
        }
    }
    
    
    convenience init(image: UIImage?, category: Category) {
        self.init()
        
        self.category = category
        self.image = image
        
//        self.key = .randomString(length: 64)
        
//        self.season = season
    }
}


class BottomWear: Wear {

    convenience init(image: UIImage?) {
        self.init()
        
        self.image = image
        
//        self.key = .randomString(length: 64)
    }

    func getCopy() -> BottomWear {
        let copy = BottomWear(image: self.image)
        if let season = self.season { copy.season = season }
        copy.key = key
        return copy
    }
}

class Shoes: Wear {
 
    convenience init(image: UIImage?) {
        self.init()
        
        self.image = image
        
//        self.key = .randomString(length: 64)
    }
    
    func getCopy() -> Shoes {
        let copy = Shoes(image: self.image)
        if let season = self.season { copy.season = season }
        copy.key = key
        return copy
    }
}

class Accessory: Wear {
    
    func getCopy() -> Accessory {
        let copy = Accessory(image: self.image, category: self.category)
        if let season = self.season { copy.season = season }
        copy.key = key
        return copy
    }
    

    enum Category: Int {
        case hat = 0
        case jewelery = 1
        case scraves = 2
        case glasses = 3
    }
    
    @objc dynamic private var categoryRawValue: String = ""
    
    private(set) var category: Category {
        get {
            return Category(rawValue: Int(categoryRawValue)!)!
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            categoryRawValue = String(describing: newValue.rawValue)
            pthread_rwlock_unlock(&lock)
        }
    }
    
    convenience init(image: UIImage?, category: Category) {
        self.init()
        
        self.category = category
        self.image = image
        
//        self.key = .randomString(length: 64)
//        self.season = season
    }
    
}
