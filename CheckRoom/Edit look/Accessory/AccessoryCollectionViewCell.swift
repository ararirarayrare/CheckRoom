//
//  AccessoryCollectionViewCell.swift
//  CheckRoom
//
//  Created by mac on 13.02.2023.
//

import UIKit

class AccessoryCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    let containerView = UIView()
    
    var accessory: Accessory!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset.height = 2
    }
    
    private func layout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 16),
            containerView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 16),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -16),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -16),
            
            
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                               constant: 12),
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                           constant: 12),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                constant: -12),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                              constant: -12),
        ])
    }
}
