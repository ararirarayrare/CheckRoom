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
        imageView.image = Icons.logo
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let headerView = MainHeaderView()
    private var outfitsView: MainOutfitsView?
    
    let coordinator: MainCoordinator
    
    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        
        navigationItem.largeTitleDisplayMode = .never
        
        headerView.coordinator = self.coordinator
        
        if let savedOutfits = DataManager.shared.savedOutfits() {
            
            let outfitsView = MainOutfitsView()
            
            if let today = savedOutfits.first(where: { Date() > $0.key })?.value {
                outfitsView.outfitViewToday = today.createPreview()
            }
            
            if let tomorrow = savedOutfits.first(where: { $0.key > Date() })?.value {
                outfitsView.outfitViewTomorrow = tomorrow.createPreview()                
            }
            
            self.outfitsView = outfitsView
        }
    }
    
    override func layout() {
        super.layout()
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(headerView)
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: 24),
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
        
        if let outfitsView = self.outfitsView {
            outfitsView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(outfitsView)

            NSLayoutConstraint.activate([
                outfitsView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
                outfitsView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
                outfitsView.topAnchor.constraint(equalTo: headerView.bottomAnchor,
                                                 constant: 24),
                outfitsView.heightAnchor.constraint(equalTo: outfitsView.widthAnchor,
                                                    multiplier: 0.7)
            ])
        }
    }
    
}

