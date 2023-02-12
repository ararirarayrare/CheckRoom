//
//  Outfit.swift
//  CheckRoom
//
//  Created by mac on 08.02.2023.
//

import UIKit
import RealmSwift

class Outfit: Object {
    
    private var lock = pthread_rwlock_t()
    private var lockAttributes = pthread_rwlockattr_t()
    
    @objc dynamic private var topWearImageData: Data = Data()
    @objc dynamic private var bottomWearImageData: Data = Data()
    @objc dynamic private var shoesImageData: Data = Data()
    @objc dynamic private var accessoryImageData: Data = Data()
    
    @objc dynamic var topWear: TopWear!
    @objc dynamic var bottomWear: BottomWear!
    @objc dynamic var shoes: Shoes!
    
//    var topWearImage: UIImage? {
//        get {
//            return UIImage(data: topWearImageData)
//        }
//
//        set {
//            pthread_rwlock_wrlock(&lock)
//            if let data = newValue?.pngData() { topWearImageData = data }
//            pthread_rwlock_unlock(&lock)
//        }
//    }
//
//    var bottomWearImage: UIImage? {
//        get {
//            return UIImage(data: bottomWearImageData)
//        }
//
//        set {
//            pthread_rwlock_wrlock(&lock)
//            if let data = newValue?.pngData() { bottomWearImageData = data }
//            pthread_rwlock_unlock(&lock)
//        }
//    }
    
//    var shoesImage: UIImage? {
//        get {
//            return UIImage(data: shoesImageData)
//        }
//
//        set {
//            pthread_rwlock_wrlock(&lock)
//            if let data = newValue?.pngData() { shoesImageData = data }
//            pthread_rwlock_unlock(&lock)
//        }
//    }
    
    var accessoryImage: UIImage? {
        get {
            return UIImage(data: accessoryImageData)
        }
        
        set {
            pthread_rwlock_wrlock(&lock)
            if let data = newValue?.pngData() { accessoryImageData = data }
            pthread_rwlock_unlock(&lock)
        }
    }
    
    
    @objc dynamic private var seasonRawValue: String = ""
    
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
        
        pthread_rwlock_init(&lock, &lockAttributes)
    }
    
    func createPreview() -> OutfitView {
        let view = OutfitView()
        
//        view.topImageView.image = topWearImage
//        view.bottomImageView.image = bottomWearImage
//        view.shoesImageView.image = shoesImage
        
        view.topImageView.image = topWear.image
        view.bottomImageView.image = bottomWear.image
        view.shoesImageView.image = shoes.image
        
        return view
    }
}

class OutfitView: UIView {
    
    let topImageView = UIImageView()
    let bottomImageView = UIImageView()
    let shoesImageView = UIImageView()
    
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
    
        topImageView.contentMode = .scaleAspectFit
        bottomImageView.contentMode = .scaleAspectFit
        shoesImageView.contentMode = .scaleAspectFit
        
        shoesImageView.backgroundColor = .clear
    }
    
    private func layout() {
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topImageView)
        addSubview(bottomImageView)
        addSubview(shoesImageView)
        
        NSLayoutConstraint.activate([
            topImageView.topAnchor.constraint(equalTo: topAnchor,
                                              constant: 8),
//            topImageView.bottomAnchor.constraint(equalTo: centerYAnchor,
//                                                 constant: -12),
            topImageView.heightAnchor.constraint(equalTo: heightAnchor,
                                                 multiplier: 0.35),
            topImageView.widthAnchor.constraint(equalTo: topImageView.heightAnchor),
            topImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            bottomImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor,
                                                 constant: 4),
            bottomImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                    constant: -8),
            bottomImageView.widthAnchor.constraint(equalTo: bottomImageView.heightAnchor),
            bottomImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            shoesImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                     constant: -24),
            shoesImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                   constant: -24),
            shoesImageView.widthAnchor.constraint(equalTo: widthAnchor,
                                                  multiplier: 0.3),
            shoesImageView.heightAnchor.constraint(equalTo: shoesImageView.widthAnchor)
        ])
    }
    
}
