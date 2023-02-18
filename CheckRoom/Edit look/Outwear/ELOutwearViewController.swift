//
//  ELOutwearViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELOutwearViewController: ViewController {
    
    private var collectionView: ItemsCollectionView?
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Save", for: .normal)
        
        button.layer.cornerRadius = 28
        
        return button
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
        
        
        let outwearItems = DataManager.shared.getWear(type: TopWear.self,
                                                      forSeason: outfit.season)
            .filter { $0.category == .outwear }
        
        guard !outwearItems.isEmpty else {
            setupOops()
            return
        }
        
        collectionView = ItemsCollectionView(
            items: outwearItems,
            frame: CGRect(x: 0,
                          y: 140,
                          width: view.bounds.width,
                          height: view.bounds.width * 1.25)
        )
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        guard let collectionView = collectionView else {
            return
        }
        
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 140),
            saveButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc
    private func saveTapped() {
        DataManager.shared.updateOutfit {
            self.outfit.outwear = self.collectionView?.selectedItem as? TopWear
        }
        
        coordinator.eventOccured(.saved)
    }
    
    @objc
    private func addItemTapped() {
        (coordinator.parent as? MainCoordinator)?.eventOccured(.addItem)
    }
    
    private func setupOops() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = "Oops..."
        
        let label = UILabel()
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        label.numberOfLines = 0
        
        label.text = "There are no outwear items in the '\(outfit.season.title)' category yet.\n\nTake a photo or add an item from your gallery!"
        
        let addItemButton = UIButton(type: .system)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = .black
        addItemButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        addItemButton.setTitleColor(.white, for: .normal)
        addItemButton.setTitle("Add item", for: .normal)
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
