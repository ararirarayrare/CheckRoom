//
//  SavedViewController.swift
//  CheckRoom
//
//  Created by mac on 10.01.2023.
//

import UIKit

class SuccessViewController: ViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = Icons.logo
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .poppinsFont(ofSize: 18)
        label.textAlignment = .center
        label.textColor = UIColor(red: 82/255, green: 82/255, blue: 82/255, alpha: 1.0)
        label.numberOfLines = 0
        
        return label
    }()
    
    private var menuButtonWidthConstraint: NSLayoutConstraint?

    private let menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        button.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Back to main screen", for: .normal)
        
        button.layer.cornerRadius = 28
        
        return button
    }()
    
    let coordinator: Coordinator
    
    init(title: String, coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func menuTapped() {
        coordinator.pop()
    }
    
    override func setup() {
        super.setup()
        
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
    }
    
    override func layout() {
        super.layout()
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(menuButton)
        
        let menuButtonWidthConstraint = menuButton.widthAnchor.constraint(equalToConstant: 260)
        self.menuButtonWidthConstraint = menuButtonWidthConstraint
        
        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor,
                                             multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                            constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor,
                                               constant: -12),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor,
                                                constant: 12),
            
            
            menuButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            menuButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            menuButton.heightAnchor.constraint(equalToConstant: 56),
            menuButtonWidthConstraint
        ])
    }
    
}
