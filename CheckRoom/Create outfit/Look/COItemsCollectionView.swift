//
//  COLookCollectionView.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class COItemsCollectionView: UICollectionView {
    
    private(set) var selectedIndex: Int = 0
    
    var selectedItem: UIImage? {
        return items[selectedIndex]
    }
    
    let items: [UIImage?]
    
    init(items: [UIImage?]) {
        self.items = items
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
        let cellClass = COItemsCollectionViewCell.self
        let identifier = String(describing: cellClass)
        
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension COItemsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: COItemsCollectionViewCell.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? COItemsCollectionViewCell else {
            return COItemsCollectionViewCell()
        }
        
        cell.imageView.image = items[indexPath.item]
        
        
        return cell
    }
    
}

class COItemsCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
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
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
