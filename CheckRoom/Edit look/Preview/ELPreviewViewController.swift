//
//  ELPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELPreviewViewController: ViewController {
    
    private let addItemsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .clear
        button.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Add items", for: .normal)
        
        button.layer.cornerRadius = 28
        
        return button
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
    
    let coordinator: ELCoordinator
    
    let outfit: Outfit
    
    private let outfitView: OutfitView
    
    private let updateHandler: (Outfit) -> Void
    
    init(coordinator: ELCoordinator,
         outfit: Outfit,
         outfitView: OutfitView,
         updateHandler: @escaping (Outfit) -> Void) {
        
        self.coordinator = coordinator
        self.outfit = outfit
        self.updateHandler = updateHandler
        self.outfitView = outfitView
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        navigationItem.largeTitleDisplayMode = .always
        
        title = "Preview"
        
        outfitView.layer.cornerRadius = 20
        
        outfitView.layer.shadowColor = UIColor.black.cgColor
        outfitView.layer.shadowRadius = 20
        outfitView.layer.shadowOpacity = 0.2
        outfitView.layer.shadowOffset.height = 2
        
        addItemsButton.addTarget(self, action: #selector(addItemsTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        outfitView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(outfitView)
        view.addSubview(addItemsButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 140),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            
            addItemsButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
                                               constant: -16),
            addItemsButton.widthAnchor.constraint(equalToConstant: 140),
            addItemsButton.heightAnchor.constraint(equalToConstant: 56),
            addItemsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            outfitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 40),
            outfitView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 20),
            outfitView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -20),
            outfitView.bottomAnchor.constraint(equalTo: addItemsButton.topAnchor,
                                              constant: -32)
        ])
    }
    
    @objc
    private func addItemsTapped() {
        coordinator.eventOccured(.addItems(outfit))
    }
    
    @objc
    private func saveTapped() {
        if DataManager.shared.containsOutfit(outfit) {
            DataManager.shared.updateOutfit {
                self.updateHandler(self.outfit)
            }
        } else {
            DataManager.shared.updateOutfit {
                self.updateHandler(self.outfit)
            }
            DataManager.shared.save(outfit: outfit)
        }
        
        coordinator.eventOccured(.saved)
    }

    
}
