//
//  CategoryCollectionView.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class CategoryCollectionView: UICollectionView {
    
    let defaultImages: [UIImage?]
    
    var activeImages: [UIImage?] {
        didSet {
            reloadData()
        }
    }
    
    private(set) var selectedItem: Int = 0
    
    init(defaultImages: [UIImage?]) {
        self.defaultImages = defaultImages
        self.activeImages = defaultImages
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
//        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        contentInset.bottom = 160
        
        delegate = self
        dataSource = self
        
        let cellClass = CategoryCollectionViewCell.self
        let identifier = String(describing: cellClass)
        
        register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CategoryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        defaultImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let identifier = String(describing: CategoryCollectionViewCell.self)
        
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? CategoryCollectionViewCell else {
            
            return CategoryCollectionViewCell()
        }
        
        let isSelected = (indexPath.item == selectedItem)
        let activeImage = activeImages[indexPath.item]
        let defaultImage = defaultImages[indexPath.item]
        
        let image = isSelected ? activeImage : defaultImage
        
        cell.button.setImage(image, for: .normal)
        cell.button.setImage(activeImage, for: .highlighted)
        
        cell.actionHandler = { [weak self] in
            self?.selectedItem = indexPath.item
            self?.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: bounds.width - 40,
                      height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

class CategoryCollectionViewCell: UICollectionViewCell {
    
    var actionHandler: (() -> Void)?
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func selected() {
        let activeImage = button.image(for: .highlighted)
        button.setImage(activeImage, for: .normal)
        
        actionHandler?()
    }
    
    
    private func setup() {
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 12
        layer.shadowOpacity = 0.15
        
        button.addTarget(self, action: #selector(selected), for: .touchUpInside)
    }
    
    private func layout() {
        addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

    }
}
