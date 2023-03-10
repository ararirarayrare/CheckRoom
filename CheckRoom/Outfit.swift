//
//  Outfit.swift
//  CheckRoom
//
//  Created by mac on 08.02.2023.
//

import UIKit
import RealmSwift

class Outfit: Object {
    
    func getCopy() -> Outfit {
        let copy = Outfit(season: self.season)
        copy.topWear = self.topWear.getCopy()
        copy.bottomWear = self.bottomWear.getCopy()
        copy.shoes = self.shoes.getCopy()
        
        copy.hat = self.hat?.getCopy()
        copy.glasses = self.glasses?.getCopy()
        copy.jewelery = self.jewelery?.getCopy()
        copy.scarves = self.scarves?.getCopy()
        
        copy.outwear = self.outwear?.getCopy()
        
        
        return copy
    }
    
    private var lock = pthread_rwlock_t()
    private var lockAttributes = pthread_rwlockattr_t()

    @objc dynamic var topWear: TopWear!
    @objc dynamic var bottomWear: BottomWear!
    @objc dynamic var shoes: Shoes!
    
    @objc dynamic var jewelery: Accessory?
    @objc dynamic var hat: Accessory?
    @objc dynamic var scarves: Accessory?
    @objc dynamic var glasses: Accessory?
    
    @objc dynamic var outwear: TopWear?
    
    @objc dynamic private var seasonRawValue: String = ""
    
    @objc dynamic private(set) var key: String! = ""

    
    var season: Season {
        get {
            return Season(rawValue: Int(seasonRawValue)! )!
        }

        set {
            pthread_rwlock_wrlock(&lock)
            seasonRawValue = String(describing: newValue.rawValue)
            
            let items = [topWear, bottomWear, shoes, hat, jewelery, glasses, scarves]
            items.forEach { $0?.season = newValue }
            
            pthread_rwlock_unlock(&lock)
        }
    }
    
    convenience init(season: Season) {
        self.init()
        
        self.season = season
        self.key = .randomString(length: 64)
        
        pthread_rwlock_init(&lock, &lockAttributes)
    }
    
    func isEqual(toOutfit outfit: Outfit?) -> Bool {
        let equals = topWear.isEqual(toWear: outfit?.topWear) &&
        bottomWear.isEqual(toWear: outfit?.bottomWear) &&
        shoes.isEqual(toWear: outfit?.shoes)
        
        return equals
    }
    
    func createPreview() -> OutfitView {
        let view = OutfitView()

        view.topImageView.image = topWear.image
        view.bottomImageView.image = bottomWear.image
        view.shoesImageView.image = shoes.image
        
        if let hat = self.hat {
            let imageView = UIImageView()
            imageView.image = hat.image
            view.hatImageView = imageView
        }
        
        if let jewelery = self.jewelery {
            let imageView = UIImageView()
            imageView.image = jewelery.image
            view.jeweleryImageView = imageView
        }
        
        if let scarves = self.scarves {
            let imageView = UIImageView()
            imageView.image = scarves.image
            view.scarvesImageView = imageView
        }
        
        if let glasses = self.glasses {
            let imageView = UIImageView()
            imageView.image = glasses.image
            view.glassesImageView = imageView
        }
        
        if let outwear = self.outwear {
            let imageView = UIImageView()
            imageView.image = outwear.image
            view.outwearImageView = imageView
        }
        
        view.setup()
        view.layout()
        
        return view
    }
}

class OutfitView: UIView {
    
    let topImageView = UIImageView()
    let bottomImageView = UIImageView()
    let shoesImageView = UIImageView()
    
    var hatImageView: UIImageView?
    var jeweleryImageView: UIImageView?
    var scarvesImageView: UIImageView?
    var glassesImageView: UIImageView?
    
    var outwearImageView: UIImageView?
    
    fileprivate func setup() {
        backgroundColor = .white
        
        let imageViews = [
            topImageView, bottomImageView, shoesImageView, hatImageView, jeweleryImageView, scarvesImageView, glassesImageView, outwearImageView
        ]
    
//        topImageView.contentMode = .scaleToFill
//        bottomImageView.contentMode = .scaleToFill
//        shoesImageView.contentMode = .scaleToFill
        
        imageViews.forEach { $0?.contentMode = .scaleToFill }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let topImageSize = topImageView.image?.size,
              let bottomImageSize = bottomImageView.image?.size,
              let shoesImageSize = shoesImageView.image?.size,
              bounds != .zero else {
            return
        }
        
        let topAspectRatio = topImageSize.width / topImageSize.height
        let bottomAspectRatio = bottomImageSize.width / bottomImageSize.height
        let shoesAspectRatio = shoesImageSize.width / shoesImageSize.height
        
        
        let topHeight = bounds.height * 0.38
        let topWidth = topHeight * topAspectRatio
        topImageView.frame.size = CGSize(width: topWidth, height: topHeight)
        
        let bottomWidth = topWidth * 0.85
        let bottomHeight = bottomWidth / bottomAspectRatio
        
        if bottomHeight > (bounds.height * 0.62 - 16) {
            
            let newBottomHeight = (bounds.height * 0.62 - 16)
            let newBottomWidth = newBottomHeight * bottomAspectRatio
            
            bottomImageView.frame.size = CGSize(width: newBottomWidth, height: newBottomHeight)
            
        } else {
            bottomImageView.frame.size = CGSize(width: bottomWidth, height: bottomHeight)
        }
        
        
        let shoesWidth = (bounds.width * 0.4)
        let shoesHeight = shoesWidth / shoesAspectRatio
        shoesImageView.frame.size = CGSize(width: shoesWidth, height: shoesHeight)
        
                
        topImageView.frame.origin.y = 8
        bottomImageView.frame.origin.y = topImageView.frame.maxY
        shoesImageView.frame.origin.y = (bounds.height - shoesHeight - 24)
        
        topImageView.frame.origin.x = (bounds.width - topImageView.bounds.width) / 2
        bottomImageView.frame.origin.x = (bounds.width - bottomImageView.bounds.width) / 2
        shoesImageView.frame.origin.x = (bounds.midX + bounds.width * 0.05)
        
        
        if let hatImageView = hatImageView,
           let imageSize = hatImageView.image?.size {
            
            let aspectRatio = imageSize.width / imageSize.height
            
            let width = bounds.width * 0.2
            let height = width / aspectRatio
            
            hatImageView.frame = CGRect(x: (bounds.width * 0.95) - width,
                                        y: 24,
                                        width: width,
                                        height: height)
        }
        
        if let glassesImageView = glassesImageView,
           let imageSize = glassesImageView.image?.size {
            
            
            let aspectRatio = imageSize.width / imageSize.height
            
            let width = bounds.width * 0.2
            let height = width / aspectRatio
            
            glassesImageView.frame = CGRect(x: bounds.width * 0.05,
                                            y: 24,
                                            width: width,
                                            height: height)
            
        }

        
        if let scarvesImageView = scarvesImageView,
           let imageSize = scarvesImageView.image?.size {
            
            let aspectRatio = imageSize.width / imageSize.height
            
            let width = bounds.width * 0.2
            let height = width / aspectRatio
            
            scarvesImageView.frame.size = CGSize(width: width, height: height)
            
            if let hatImageView = self.hatImageView {
                scarvesImageView.frame.origin.y = hatImageView.frame.maxY + 8
                scarvesImageView.center.x = hatImageView.frame.midX
            } else {
                scarvesImageView.frame.origin.y = 32
                scarvesImageView.frame.origin.x = (bounds.width * 0.9) - width
            }
            
        }
        
        if let jeweleryImageView = jeweleryImageView,
           let imageSize = jeweleryImageView.image?.size {
            
            let aspectRatio = imageSize.width / imageSize.height
            
            let width = bounds.width * 0.2
            let height = width / aspectRatio
            
            jeweleryImageView.frame.size = CGSize(width: width, height: height)
            
            if let glassesImageView = self.glassesImageView {
                jeweleryImageView.frame.origin.y = glassesImageView.frame.maxY + 8
                jeweleryImageView.center.x = glassesImageView.frame.midX
            } else {
                jeweleryImageView.frame.origin.y = 32
                jeweleryImageView.frame.origin.x = bounds.width * 0.1
            }
            
        }
        
        
        if let outwearImageView = outwearImageView,
           let imageSize = outwearImageView.image?.size {
            
            let aspectRatio = imageSize.width / imageSize.height
            
            let width = topWidth * 1.1
            let height = width / aspectRatio
            
            outwearImageView.frame.size = CGSize(width: width, height: height)
            
            outwearImageView.frame.origin.x = 4 /* topImageView.frame.origin.x - 12 */
            outwearImageView.frame.origin.y = 4 /* topImageView.frame.origin.y - 12 */
            
        }
        
    }
    
    
    fileprivate func layout() {
        
        addSubview(topImageView)
        addSubview(bottomImageView)
        addSubview(shoesImageView)
        
        [hatImageView, glassesImageView, jeweleryImageView, scarvesImageView]
            .compactMap { $0 }
            .forEach { addSubview($0) }
        
        if let outwearImageView = outwearImageView {
            insertSubview(outwearImageView, belowSubview: topImageView)
        }
        
    }
    
}
