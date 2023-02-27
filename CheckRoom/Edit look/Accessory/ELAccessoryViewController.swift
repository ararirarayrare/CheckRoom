//
//  ELAccessoryViewController.swift
//  CheckRoom
//
//  Created by mac on 13.02.2023.
//

import UIKit

class ELAccessoryViewController: ViewController {
    
    private var collectionView: AccessoryCollectionView?
    
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
        
        var accessoryTitle = String(describing: accessoryCategory)
        let firstLetter = accessoryTitle.removeFirst().uppercased()
        
        title = firstLetter + accessoryTitle
        
        let accessories = DataManager.shared.getWear(type: Accessory.self,
                                                     forSeason: outfit.season)
            .filter { $0.category == self.accessoryCategory }
        
        guard !accessories.isEmpty else {
            setupOops()
            return
        }
        
        collectionView = AccessoryCollectionView(accessories: accessories)
        
        addButton.backgroundColor = .black
        addButton.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitle("Add", for: .normal)
        addButton.layer.cornerRadius = 28
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        guard let collectionView = collectionView else {
            return
        }
        
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
        
        if let accessory = collectionView?.selectedItem, accessory.category == .hat {
            
            DataManager.shared.updateOutfit {
                self.outfit.hat = accessory
            }
            
            if !DataManager.shared.contains(outfit) {
                DataManager.shared.save(outfit: outfit)
            }
            
            coordinator.eventOccured(.saved)
        }
        
    }
    
    @objc
    private func addItemTapped() {
        (coordinator.parent as? MainCoordinator)?.eventOccured(.addItem)
    }
    
    private func setupOops() {
        navigationItem.backButtonDisplayMode = .minimal
        
        let label = UILabel()
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        label.numberOfLines = 0
        
        var accessoryTitle = String(describing: accessoryCategory)
        let firstLetter = accessoryTitle.removeFirst().uppercased()
        accessoryTitle = firstLetter + accessoryTitle
        
        label.text = "There are no items in the '\(accessoryTitle)' category yet.\n\nCreate it right now!"
        
        
        let addItemButton = UIButton(type: .system)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = .black
        addItemButton.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        addItemButton.setTitleColor(.white, for: .normal)
        addItemButton.setTitle("Create a look", for: .normal)
        addItemButton.layer.cornerRadius = 28
        addItemButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(addItemButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 48),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -48),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: 40),
            
            
            addItemButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -32),
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.widthAnchor.constraint(equalToConstant: 180),
            addItemButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
}
