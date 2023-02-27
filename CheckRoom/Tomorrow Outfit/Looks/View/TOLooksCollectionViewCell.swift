//
//  COLookCollectionViewCell.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class TOLooksCollectionViewCell: UICollectionViewCell {
    
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
            outfitView.layer.shadowOpacity = 0.1
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

}
