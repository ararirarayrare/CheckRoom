//
//  ViewController.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class MainViewController: ViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let headerView: MainHeaderView = {
        let headerView = MainHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        return headerView
    }()
    
    let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setup()
        layout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    private func setup() {
        view.backgroundColor = .white
        headerView.coordinator = self.coordinator
    }
    
    private func layout() {
        view.addSubview(logoImageView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: 0),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor,
                                                  multiplier: 1.12),
            
            
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                constant: 20),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                 constant: -20),
            headerView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor,
                                            constant: 32)
        ])
    }
    
}

