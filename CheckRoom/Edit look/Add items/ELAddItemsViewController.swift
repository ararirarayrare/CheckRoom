//
//  ELAddItemsViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELAddItemsViewController: ViewController {
    
    private let collectionView: CategoryCollectionView = {
        let images = [
            UIImage(named: "outerwear-subcategory-top"),
            UIImage(named: "undercoat-subcategory-top")
        ]
        
        let activeImages = [
            UIImage(named: "outerwear-subcategory-top-active"),
            UIImage(named: "undercoat-subcategory-top-active")
        ]
        
        let collectionView = CategoryCollectionView(defaultImages: images)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.activeImages = activeImages

        return collectionView
    }()
    
    let coordinator: ELCoordinator
    
    init(coordinator: ELCoordinator, look: UIImage?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        title = "Add to subcategory"
        
        collectionView.selectionDelegate = self
    }
    
    override func layout() {
        super.layout()
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
}

extension ELAddItemsViewController: CategoryCollectionViewDelegateSelection {
    func collectionView(_ collectionView: CategoryCollectionView, didSelectItemAt index: Int) {
        
        let outwear = UIImage(named: "outwear-item")
        
        switch index {
        case 0:
            coordinator.eventOccured(.outwear(outwear))
        case 1:
//            coordinator.eventOccured(<#T##event: ELCoordinator.Event##ELCoordinator.Event#>)
        }
        
    }
}
