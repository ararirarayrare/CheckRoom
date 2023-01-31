//
//  Wear.swift
//  CheckRoom
//
//  Created by mac on 31.01.2023.
//

import UIKit

protocol Wear {
    var image: UIImage? { get }
    var season: Season! { get set }
}

class TopWear: Wear {
    
    var image: UIImage?
    
    var season: Season!
    
    enum Category: Int {
        case outwear = 0
        case undercoat = 1
    }
    
    let category: Category
    
    init(image: UIImage?, category: Category) {
        self.category = category
        self.image = image
//        self.season = season
    }
}


class BottomWear: Wear {
    
    var image: UIImage?
    
    var season: Season!
    
    init(image: UIImage?) {
        self.image = image
//        self.season = season
    }
    
}

class Shoes: Wear {
    var image: UIImage?
    
    var season: Season!
    
    init(image: UIImage?) {
        self.image = image
//        self.season = season
    }
    
}

class Accessory: Wear {
    
    var image: UIImage?
    
    var season: Season!
    
    enum Category: Int {
        case hat = 0
        case jewelery = 1
        case scrave = 2
        case glasses = 3
    }
    
    let category: Category
    
    init(image: UIImage?, category: Category) {
        self.category = category
        self.image = image
//        self.season = season
    }
    
}
