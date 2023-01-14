//
//  COPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class TOPreviewViewController: ViewController {
    
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
    
    let coordinator: TOCoordinator
    
    init(coordinator: TOCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        title = "Preview"
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(imageView)
        view.addSubview(editButton)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
//            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
//                                           constant: 40),
//            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
//                                               constant: 20),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
//                                                constant: -20),
//            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor,
//                                              multiplier: 1.2),
            
            
//            editButton.topAnchor.constraint(equalTo: imageView.bottomAnchor,
//                                            constant: 32),
//            editButton.widthAnchor.constraint(equalToConstant: 140),
//            editButton.heightAnchor.constraint(equalToConstant: 56),
//            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
//            saveButton.topAnchor.constraint(equalTo: editButton.bottomAnchor,
//                                            constant: 16),
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
            
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: 40),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                               constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -20),
            imageView.bottomAnchor.constraint(equalTo: editButton.topAnchor,
                                              constant: -32)
        ])
    }
    
    @objc
    private func saveTapped() {
        coordinator.eventOccured(.saved)
    }
}
