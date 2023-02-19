//
//  COLooksCollectionView.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

protocol TOLooksCollectionViewDelegateSelection: AnyObject {
    func collectionView(_ collectionView: TOLooksCollectionView, didSelectOutfit outfit: Outfit)
}

class TOLooksCollectionView: UICollectionView {
    
    weak var selectionDelegate: TOLooksCollectionViewDelegateSelection?
    
    let outfits: [Outfit]
    
    init(outfits: [Outfit]) {
        self.outfits = outfits
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        let cellClass = TOLooksCollectionViewCell.self
        let identifier = String(describing: cellClass)
        
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TOLooksCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return outfits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: TOLooksCollectionViewCell.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? TOLooksCollectionViewCell else {
            return TOLooksCollectionViewCell()
        }
        
//        cell.imageView.image = looks[indexPath.item]
//        cell.imageView.isUserInteractionEnabled = true
        
        cell.outfit = outfits[indexPath.item]
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cellTapped(_:)))
//        cell.isUserInteractionEnabled = true
//
//        cell.outfitView.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = bounds.width / 2 - 8
        return CGSize(width: width,
                      height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionDelegate?.collectionView(self, didSelectOutfit: outfits[indexPath.item])
    }
}
