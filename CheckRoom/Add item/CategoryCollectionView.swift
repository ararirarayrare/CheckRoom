//
//  CategoryCollectionView.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit
import Combine

protocol CategoryCollectionViewDelegateSelection: AnyObject {
    func collectionView(_ collectionView: CategoryCollectionView, didSelectItemAt index: Int)
}

class CategoryCollectionView: UICollectionView {
    
    weak var selectionDelegate: CategoryCollectionViewDelegateSelection?
    
    let defaultImages: [UIImage?]
    
    var activeImages: [UIImage?] {
        didSet {
            reloadData()
        }
    }
    
    @Published
    var selectedItems: Set<Int> = [0]
    
    
    var multipleSelection: Bool = false
    
    init(defaultImages: [UIImage?]) {
        self.defaultImages = defaultImages
        self.activeImages = defaultImages
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
//        layout.minimumInteritemSpacing = 12
        layout.scrollDirection = .vertical
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        
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
        
        let isSelected = selectedItems.contains(indexPath.item)
        let activeImage = activeImages[indexPath.item]
        let defaultImage = defaultImages[indexPath.item]
        
        let image = isSelected ? activeImage : defaultImage
        
        cell.button.setImage(image, for: .normal)
        cell.button.setImage(activeImage, for: .highlighted)
        
        cell.actionHandler = { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.multipleSelection {
                
                if isSelected {
                    self.selectedItems.remove(indexPath.item)
                } else {
                    self.selectedItems.insert(indexPath.item)
                }

            } else {
                self.selectedItems = [indexPath.item]
            }
            
            if let selectionDelegate = self.selectionDelegate {
                selectionDelegate.collectionView(self, didSelectItemAt: indexPath.item)
            } else {
                self.reloadData()
            }
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = bounds.width - 40
        let height = width / 2.58
        
        return CGSize(width: width, height: height)
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
        backgroundColor = .clear
        
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowRadius = 12
//        layer.shadowOpacity = 0.15
        
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
