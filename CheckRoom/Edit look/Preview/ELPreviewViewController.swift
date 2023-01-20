//
//  ELPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELPreviewViewController: ViewController {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.layer.cornerRadius = 20
        
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 20
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.shadowOffset.height = 2
        
        return imageView
    }()
    
    private let addItemsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .clear
        button.titleLabel?.font = .boldSystemFont(ofSize: 22)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Add items", for: .normal)
        
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
    
    let coordinator: ELCoordinator
    
    init(coordinator: ELCoordinator, look: UIImage?) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        title = "Preview"
        
        addItemsButton.addTarget(self, action: #selector(addItemsTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(imageView)
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
            
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -20),
            imageView.bottomAnchor.constraint(equalTo: addItemsButton.topAnchor,
                                              constant: -32)
        ])
    }
    
    @objc
    private func addItemsTapped() {
        let look = UIImage(named: "look-example")
        
        coordinator.eventOccured(.addItems(look))
    }
    
    @objc
    private func saveTapped() {
//        let look = UIImage(named: "look-example")
        
        coordinator.eventOccured(.saved)
    }

    
}
