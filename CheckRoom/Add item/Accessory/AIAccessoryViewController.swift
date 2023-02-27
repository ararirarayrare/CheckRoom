//
//  AccessoryViewController.swift
//  CheckRoom
//
//  Created by mac on 10.01.2023.
//

import UIKit

class AIAccessoryViewController: ViewController {
    
    private let collectionView: CategoryCollectionView = {
        let images = [
            UIImage(named: "hats-accessory"),
            UIImage(named: "jewelery-accessory"),
            UIImage(named: "scarves-accessory"),
            UIImage(named: "glasses-accessory")
        ]
        
        let activeImages = [
            UIImage(named: "hats-accessory-active"),
            UIImage(named: "jewelery-accessory-active"),
            UIImage(named: "scarves-accessory-active"),
            UIImage(named: "glasses-accessory-active")
        ]
        
        let collectionView = CategoryCollectionView(defaultImages: images)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.activeImages = activeImages

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
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        button.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Save", for: .normal)
        
        button.layer.cornerRadius = 28
        
        return button
    }()
    
    let coordinator: AICoordinator
    
    private let image: UIImage?
    
    init(coordinator: AICoordinator, image: UIImage?) {
        self.coordinator = coordinator
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func saveTapped() {
        //MARK: - REDO!!!
        if let accessoryType = Accessory.Category(rawValue: collectionView.selectedItems.first!) {
            let accessory = Accessory(image: self.image,
                                      category: accessoryType)
            coordinator.eventOccured(.season(wear: accessory))
        }
    }
    
    override func setup() {
        super.setup()
        title = "Add accessory to"
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        view.addSubview(collectionView)
        view.addSubview(shadowView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 140),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            
            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            shadowView.topAnchor.constraint(equalTo: saveButton.bottomAnchor)
        ])
    }
}

