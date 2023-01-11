//
//  COLookCollectionViewCell.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class COLooksCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 20
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 0.3
        
        imageView.backgroundColor = .gray
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                               constant: 16),
            imageView.topAnchor.constraint(equalTo: topAnchor,
                                           constant: 16),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                constant: -16),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor,
                                              constant: -16)
        ])
    }
    
}
