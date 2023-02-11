//
//  COLookCollectionViewCell.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class TOLooksCollectionViewCell: UICollectionViewCell {
    
//    let containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//
//        view.backgroundColor = .white
//
//        view.layer.cornerRadius = 20
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowRadius = 8
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowOffset.height = 2
//
//        return view
//    }()
    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        imageView.layer.cornerRadius = 20
//        imageView.layer.masksToBounds = true
//
////        imageView.layer.shadowColor = UIColor.black.cgColor
////        imageView.layer.shadowRadius = 8
////        imageView.layer.shadowOpacity = 0.4
////        imageView.layer.shadowOffset.height = 2
//
//        return imageView
//    }()
    
    private(set) var outfitView: OutfitView!
    
    var outfit: Outfit! {
        didSet {
            guard let outfitView = outfit?.createPreview() else {
                return
            }
            
            self.outfitView = outfitView
            
            outfitView.layer.cornerRadius = 20
            outfitView.layer.shadowColor = UIColor.black.cgColor
            outfitView.layer.shadowRadius = 8
            outfitView.layer.shadowOpacity = 0.2
            outfitView.layer.shadowOffset.height = 2
            
            outfitView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(outfitView)
            
            NSLayoutConstraint.activate([
                outfitView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                   constant: 16),
                outfitView.topAnchor.constraint(equalTo: topAnchor,
                                               constant: 16),
                outfitView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                    constant: -16),
                outfitView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                                  constant: -16),
            ])
        }
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        isUserInteractionEnabled = true
//        
////        layout()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setOutfitView(_ outfitView: OutfitView) {
//        self.outfitView = outfitView
//        
//        outfitView.layer.shadowColor = UIColor.black.cgColor
//        outfitView.layer.shadowRadius = 20
//        outfitView.layer.shadowOpacity = 0.2
//        outfitView.layer.shadowOffset.height = 2
//        
//        layout()
//    }
//    
//    private func layout() {
////        addSubview(containerView)
////        containerView.addSubview(imageView)
////
////        NSLayoutConstraint.activate([
////            containerView.leadingAnchor.constraint(equalTo: leadingAnchor,
////                                               constant: 16),
////            containerView.topAnchor.constraint(equalTo: topAnchor,
////                                           constant: 16),
////            containerView.trailingAnchor.constraint(equalTo: trailingAnchor,
////                                                constant: -16),
////            containerView.bottomAnchor.constraint(equalTo: bottomAnchor,
////                                              constant: -16),
////
////
////            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
////            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
////            imageView.topAnchor.constraint(equalTo: containerView.topAnchor),
////            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
////        ])
//        
//        outfitView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(outfitView)
//        
//        NSLayoutConstraint.activate([
//            outfitView.leadingAnchor.constraint(equalTo: leadingAnchor,
//                                               constant: 16),
//            outfitView.topAnchor.constraint(equalTo: topAnchor,
//                                           constant: 16),
//            outfitView.trailingAnchor.constraint(equalTo: trailingAnchor,
//                                                constant: -16),
//            outfitView.bottomAnchor.constraint(equalTo: bottomAnchor,
//                                              constant: -16),
//        ])
//    }
//    
}
