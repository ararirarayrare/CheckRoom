//
//  AccessoryCollectionView.swift
//  CheckRoom
//
//  Created by mac on 13.02.2023.
//

import UIKit

class AccessoryCollectionView: UICollectionView {
    
    
    private(set) var accessories: [Accessory]
    
    var selectedIndex: Int = 0 {
        didSet {
            
            visibleCells.compactMap { $0 as? AccessoryCollectionViewCell }
                .forEach {
                    $0.containerView.layer.borderColor = UIColor.clear.cgColor
                    $0.containerView.layer.shadowOpacity = 0.2
                }
            
            let indexPath = IndexPath(item: selectedIndex, section: 0)
                
            if let cell = cellForItem(at: indexPath) as? AccessoryCollectionViewCell {
                
                cell.containerView.layer.borderColor = UIColor.black.cgColor
                cell.containerView.layer.borderWidth = 1.75
                cell.containerView.layer.shadowOpacity = 0
                
//                selectedIndex = indexPath.item
            }
        }
    }
    
    var selectedItem: Accessory? {
        return (selectedIndex >= 0 && !accessories.isEmpty) ? accessories[selectedIndex] : nil
    }
    
    init(accessories: [Accessory]) {
        self.accessories = accessories
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        let cellClass = AccessoryCollectionViewCell.self
        let identifier = String(describing: cellClass)
        
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteItems(at indexPaths: [IndexPath]) {
        indexPaths.forEach { self.accessories.remove(at: $0.item) }
        
        super.deleteItems(at: indexPaths)
        
        reloadData()
        
        self.selectedIndex = 0
    }
}

extension AccessoryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accessories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: AccessoryCollectionViewCell.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? AccessoryCollectionViewCell else {
            return AccessoryCollectionViewCell()
        }

        cell.imageView.image = accessories[indexPath.item].image
        cell.accessory = accessories[indexPath.item]
        
        if indexPath.item == selectedIndex {
            cell.containerView.layer.borderColor = UIColor.black.cgColor
            cell.containerView.layer.borderWidth = 1.75
            cell.containerView.layer.shadowOpacity = 0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = bounds.width / 2 - 8
        return CGSize(width: width,
                      height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 8, bottom: 60, right: 8)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.item
        
    }
    
}
