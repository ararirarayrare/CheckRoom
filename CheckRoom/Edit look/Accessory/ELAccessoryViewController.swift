//
//  ELAccessoryViewController.swift
//  CheckRoom
//
//  Created by mac on 13.02.2023.
//

import UIKit

class ELAccessoryViewController: ViewController {
    
    private var collectionView: AccessoryCollectionView!
    
    private let addButton = UIButton()
    
    let coordinator: ELCoordinator
    
    let outfit: Outfit
    
    let accessoryCategory: Accessory.Category
    
    init(coordinator: ELCoordinator, outfit: Outfit, accessoryCategory: Accessory.Category) {
        self.coordinator = coordinator
        self.outfit = outfit
        self.accessoryCategory = accessoryCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setup() {
        super.setup()
        
        let accessories = DataManager.shared.getWear(type: Accessory.self,
                                                     forSeason: outfit.season)
        collectionView = AccessoryCollectionView(accessories: accessories)
        
        addButton.backgroundColor = .black
        addButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitle("Add", for: .normal)
        addButton.layer.cornerRadius = 28
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        

        var accessoryTitle = String(describing: accessoryCategory)
        let firstLetter = accessoryTitle.removeFirst().uppercased()
        
        title = firstLetter + accessoryTitle
    }
    
    override func layout() {
        super.layout()
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 140),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
 
    @objc
    private func addTapped() {
        
        if let accessory = collectionView.selectedItem, accessory.category == .hat {
            
            DataManager.shared.updateOutfit {
                self.outfit.hat = accessory
            }
            
            if !DataManager.shared.contains(outfit) {
                DataManager.shared.save(outfit: outfit)
            }
            
            coordinator.eventOccured(.saved)
        }
        
    }
    
}
