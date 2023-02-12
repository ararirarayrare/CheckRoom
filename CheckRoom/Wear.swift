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
    
    var season: Season {
        get {
            return Season(rawValue: Int(seasonRawValue)! )!
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

}

class TopWear: Wear {
    
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

//        self.season = season
    }
}


class BottomWear: Wear {

    convenience init(image: UIImage?) {
        self.init()
        
        self.image = image
    }
    
}

class Shoes: Wear {
 
    convenience init(image: UIImage?) {
        self.init()
        
        self.image = image
    }
    
}

class Accessory: Wear {

    enum Category: Int {
        case hat = 0
        case jewelery = 1
        case scrave = 2
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
//        self.season = season
    }
    
}
