//
//  Outfit.swift
//  CheckRoom
//
//  Created by mac on 08.02.2023.
//

import UIKit
import RealmSwift

class Outfit: Object {
    
    @objc dynamic private var topWearImageData: Data = Data()
    @objc dynamic private var bottomWearImageData: Data = Data()
    @objc dynamic private var shoesImageData: Data = Data()
    @objc dynamic private var accessoryImageData: Data = Data()
    
    var topWearImage: UIImage? {
        get {
            return UIImage(data: topWearImageData)
        }
        
        set {
            if let data = newValue?.pngData() { topWearImageData = data }
        }
    }
    
    var bottomWearImage: UIImage? {
        get {
            return UIImage(data: bottomWearImageData)
        }
        
        set {
            if let data = newValue?.pngData() { bottomWearImageData = data }
        }
    }
    
    var shoesImage: UIImage? {
        get {
            return UIImage(data: shoesImageData)
        }
        
        set {
            if let data = newValue?.pngData() { shoesImageData = data }
        }
    }
    
    var accessoryImage: UIImage? {
        get {
            return UIImage(data: accessoryImageData)
        }
        
        set {
            if let data = newValue?.pngData() { accessoryImageData = data }
        }
    }
    
    
    @objc dynamic private var seasonRawValue: String = ""
    
    var season: Season {
        get {
            return Season(rawValue: Int(seasonRawValue)! )!
        }

        set {
            seasonRawValue = String(describing: newValue.rawValue)
        }
    }
    
    convenience init(season: Season) {
        self.init()
        
        self.season = season
    }
    
}

