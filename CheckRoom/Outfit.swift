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

    @objc dynamic var topWear: TopWear!
    @objc dynamic var bottomWear: BottomWear!
    @objc dynamic var shoes: Shoes!
    @objc dynamic var hat: Accessory?
    @objc dynamic var outwear: TopWear?
    
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
    
    private func layout() {
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        bottomImageView.translatesAutoresizingMaskIntoConstraints = false
        shoesImageView.translatesAutoresizingMaskIntoConstraints = false
        accessoryImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(topImageView)
        addSubview(bottomImageView)
        addSubview(shoesImageView)
        addSubview(accessoryImageView)
        
        fatalError("REDO LAYOUT !!!! LIKE IN ITEMS COLLECTION VIEW!!! ACCOORDING TO IMAGE ASPECT RATIO")
        //MARK: - TODO !!!
        NSLayoutConstraint.activate([
//            topImageView.topAnchor.constraint(equalTo: topAnchor,
//                                              constant: 8),
//            topImageView.heightAnchor.constraint(equalTo: heightAnchor,
//                                                 multiplier: 0.35),
//            topImageView.widthAnchor.constraint(equalTo: topImageView.heightAnchor),
//            topImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//
//
//            bottomImageView.topAnchor.constraint(equalTo: topImageView.bottomAnchor,
//                                                 constant: 4),
//            bottomImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
//                                                    constant: -8),
//            bottomImageView.widthAnchor.constraint(equalTo: bottomImageView.heightAnchor),
//            bottomImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
//            shoesImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
//                                                     constant: -24),
//            shoesImageView.bottomAnchor.constraint(equalTo: bottomAnchor,
//                                                   constant: -24),
//            shoesImageView.widthAnchor.constraint(equalTo: widthAnchor,
//                                                  multiplier: 0.3),
//            shoesImageView.heightAnchor.constraint(equalTo: shoesImageView.widthAnchor),
//
//
//            accessoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
//                                                     constant: -24),
//            accessoryImageView.bottomAnchor.constraint(equalTo: shoesImageView.topAnchor,
//                                                   constant: -24),
//            accessoryImageView.widthAnchor.constraint(equalTo: widthAnchor,
//                                                  multiplier: 0.3),
//            accessoryImageView.heightAnchor.constraint(equalTo: accessoryImageView.widthAnchor),
        ])
    }
    
}
