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
        copy.outwear = self.outwear?.getCopy()
        
        return copy
    }
    
    private var lock = pthread_rwlock_t()
    private var lockAttributes = pthread_rwlockattr_t()

    @objc dynamic var topWear: TopWear!
    @objc dynamic var bottomWear: BottomWear!
    @objc dynamic var shoes: Shoes!
    @objc dynamic var hat: Accessory?
    @objc dynamic var outwear: TopWear?
    
    @objc dynamic private var seasonRawValue: String = ""
    
    @objc dynamic private(set) var key: String! = ""
//    {
//
//        if let topData = topWear.image?.pngData(),
//           let bottomData = bottomWear.image?.pngData(),
//           let shoesData = shoes.image?.pngData() {
//
////            let top = String(topData.replacingOccurrences(of: " ", with: "").dropFirst(topData.count - 16))
////            let bottom = String(bottomData.replacingOccurrences(of: " ", with: "").dropFirst(bottomData.count - 16))
////            let shoes = String(shoesData.replacingOccurrences(of: " ", with: "").dropFirst(shoesData.count - 16))
////
////            print(top + bottom + shoes + String(describing: season))
////            return top + bottom + shoes + String(describing: season)
//
//            return ""
//        }
//
//        return nil
//    }
    
    var season: Season {
        get {
            return Season(rawValue: Int(seasonRawValue)! )!
        }

        set {
            pthread_rwlock_wrlock(&lock)
            seasonRawValue = String(describing: newValue.rawValue)
            
            topWear?.season = newValue
            bottomWear?.season = newValue
            shoes?.season = newValue
            
            pthread_rwlock_unlock(&lock)
        }
    }
    
    convenience init(season: Season) {
        self.init()
        
        self.season = season
        self.key = .randomString(length: 64)
                
        pthread_rwlock_init(&lock, &lockAttributes)
    }
    
    func createPreview() -> OutfitView {
        let view = OutfitView()

        view.topImageView.image = topWear.image
        view.bottomImageView.image = bottomWear.image
        view.shoesImageView.image = shoes.image
        view.accessoryImageView.image = hat?.image
        
        return view
    }
}

class OutfitView: UIView {
    
    let topImageView = UIImageView()
    let bottomImageView = UIImageView()
    let shoesImageView = UIImageView()
    
    let accessoryImageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .white
    
        topImageView.contentMode = .scaleToFill
        bottomImageView.contentMode = .scaleToFill
        shoesImageView.contentMode = .scaleToFill
        accessoryImageView.contentMode = .scaleToFill
        
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
    }
    
    
    private func layout() {
//        topImageView.translatesAutoresizingMaskIntoConstraints = false
//        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
//        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
//        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(topImageView)
        addSubview(bottomImageView)
        addSubview(shoesImageView)
//        addSubview(accessoryImageView)
        
                
//        NSLayoutConstraint.activate([
//            topImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
//            topImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4),
//            topImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//
//
//            bottomImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor),
//            bottomImageView.widthAnchor.constraint(equalTo: topImageView.widthAnchor,
//                                                   multiplier: 0.85),
//            bottomImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//
//
//            shoesImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
//            shoesImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24),
//            shoesImageView.leadingAnchor.constraint(equalTo: centerXAnchor,
//                                                    constant: 24)
//        ])
    }
    
}
