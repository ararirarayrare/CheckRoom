//
//  MOPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class MOPreviewViewController: ViewController {
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Edit look", for: .normal)
                
        return button
    }()
    
    private let changeSeasonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Change season", for: .normal)
                
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .mediumPoppinsFont(ofSize: 20)
        let customGray = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        button.setTitleColor(customGray, for: .normal)
        button.setTitle("Delete outfit", for: .normal)
                
        return button
    }()
    
    private let outfitView: OutfitView
    
    let outfit: Outfit
    
    let coordinator: MOCoordinator
    
    init(coordinator: MOCoordinator, outfit: Outfit) {
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
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        changeSeasonButton.addTarget(self, action: #selector(changeSeasonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        outfitView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(outfitView)
        view.addSubview(editButton)
        view.addSubview(changeSeasonButton)
        view.addSubview(deleteButton)
        
        
        NSLayoutConstraint.activate([
            deleteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                 constant: -12),
            deleteButton.heightAnchor.constraint(equalToConstant: 48),
            deleteButton.widthAnchor.constraint(equalToConstant: 160),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            changeSeasonButton.bottomAnchor.constraint(equalTo: deleteButton.topAnchor,
                                                       constant: -12),
            changeSeasonButton.heightAnchor.constraint(equalToConstant: 48),
            changeSeasonButton.widthAnchor.constraint(equalToConstant: 200),
            changeSeasonButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            editButton.bottomAnchor.constraint(equalTo: changeSeasonButton.topAnchor,
                                               constant: -12),
            editButton.widthAnchor.constraint(equalToConstant: 140),
            editButton.heightAnchor.constraint(equalToConstant: 48),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),


            outfitView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 20),
            outfitView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 20),
            outfitView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -20),
            outfitView.bottomAnchor.constraint(equalTo: editButton.topAnchor,
                                              constant: -20)
        ])
    }
    
    @objc
    private func editTapped() {
        (coordinator.parent as? MainCoordinator)?.eventOccured(.editOutfit(outfit))
    }
    
    @objc
    private func changeSeasonTapped() {
        coordinator.eventOccured(.changeSeason(forOutfit: outfit))
    }
    
    @objc
    private func deleteTapped() {
        
        let alert = UIAlertController(title: "Warning!",
                                      message: "Are you sure you want to delete this outfit?",
                                      preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            DataManager.shared.deleteOutfit(self.outfit)
            self.coordinator.eventOccured(.deleted)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true)
        
    }
}

