//
//  ELAccessoryCategoriesViewController.swift
//  CheckRoom
//
//  Created by mac on 13.02.2023.
//

import UIKit

class ELAccessoryCategoriesViewController: ViewController {
    
    
    private let collectionView: CategoryCollectionView = {
        let images = [
            UIImage(named: "hats-accessory"),
            UIImage(named: "jewelery-accessory"),
            UIImage(named: "scarves-accessory"),
            UIImage(named: "glasses-accessory")
        ]

        let collectionView = CategoryCollectionView(defaultImages: images)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 16
        view.layer.shadowOffset.height = -32
        
        return view
    }()
    
    let coordinator: ELCoordinator
    
    let outfit: Outfit
    
    init(coordinator: ELCoordinator, outfit: Outfit) {
        self.coordinator = coordinator
        self.outfit = outfit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func setup() {
        super.setup()
        
        navigationItem.largeTitleDisplayMode = .always
        
        title = "Add accessories"
        
        collectionView.selectionDelegate = self
    }
    
    override func layout() {
        super.layout()
        view.addSubview(collectionView)
        view.addSubview(shadowView)

        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    
}


extension ELAccessoryCategoriesViewController: CategoryCollectionViewDelegateSelection {
    func collectionView(_ collectionView: CategoryCollectionView, didSelectItemAt index: Int) {
        
        if let category = Accessory.Category(rawValue: index) {
            coordinator.eventOccured(.accessory(category: category, outfit: outfit))
        }
        
    }
}
