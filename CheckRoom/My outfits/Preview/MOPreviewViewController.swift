//
//  MOPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class MOPreviewViewController: ViewController {
    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        imageView.layer.cornerRadius = 20
//
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowRadius = 20
//        imageView.layer.shadowOpacity = 0.2
//        imageView.layer.shadowOffset.height = 2
//
//        return imageView
//    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Edit look", for: .normal)
                
        return button
    }()
    
    private let changeSeasonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Change season", for: .normal)
                
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
        
        changeSeasonButton.addTarget(self, action: #selector(changeSeasonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        outfitView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(outfitView)
        view.addSubview(editButton)
        view.addSubview(changeSeasonButton)
        
        NSLayoutConstraint.activate([
            changeSeasonButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                       constant: -32),
            changeSeasonButton.heightAnchor.constraint(equalToConstant: 56),
            changeSeasonButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                        constant: 32),
            changeSeasonButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                         constant: -32),
            
            
            editButton.bottomAnchor.constraint(equalTo: changeSeasonButton.topAnchor,
                                               constant: -12),
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
        // MARK: - TODO !!! 
//        let look = outfit.image
//        (coordinator.parent as? MainCoordinator)?.eventOccured(.editLook(look))
    }
    
    @objc
    private func changeSeasonTapped() {
        coordinator.eventOccured(.changeSeason(forOutfit: outfit))
    }
}

