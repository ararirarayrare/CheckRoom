//
//  COPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class TOPreviewViewController: ViewController {
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .clear
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Edit look", for: .normal)
        
        button.layer.cornerRadius = 28
        
        return button
    }()
    
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
    
    private let outfitView: OutfitView
    
    let coordinator: TOCoordinator
    
    let outfit: Outfit
    
    init(coordinator: TOCoordinator, outfit: Outfit) {
        self.coordinator = coordinator
        self.outfit = outfit
        self.outfitView = outfit.createPreview()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        title = "Preview"
        
        outfitView.layer.cornerRadius = 20
        
        outfitView.layer.shadowColor = UIColor.black.cgColor
        outfitView.layer.shadowRadius = 20
        outfitView.layer.shadowOpacity = 0.2
        outfitView.layer.shadowOffset.height = 2
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        outfitView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(outfitView)
        view.addSubview(editButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 140),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            
            editButton.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
                                               constant: -16),
            editButton.widthAnchor.constraint(equalToConstant: 140),
            editButton.heightAnchor.constraint(equalToConstant: 56),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            outfitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 40),
            outfitView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 20),
            outfitView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -20),
            outfitView.bottomAnchor.constraint(equalTo: editButton.topAnchor,
                                              constant: -32)
        ])
    }
    
    @objc
    private func editTapped() {
        (coordinator.parent as? MainCoordinator)?.eventOccured(.editOutfit(outfit))
    }
    
    @objc
    private func saveTapped() {
        //MARK: - TODO !!! what after????
        coordinator.eventOccured(.saved)
    }
}
