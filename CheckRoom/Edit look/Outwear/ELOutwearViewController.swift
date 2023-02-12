//
//  ELOutwearViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELOutwearViewController: ViewController {
    
    private lazy var collectionView = ItemsCollectionView(
        items: [],
        frame: CGRect(x: 0,
                      y: 140,
                      width: view.bounds.width,
                      height: view.bounds.width * 1.25)
    )
    
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
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
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
        coordinator.eventOccured(.saved)
    }
}
