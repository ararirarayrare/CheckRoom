//
//  COSeasonViewController.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class COSeasonsViewController: ViewController {
    
    private let collectionView: CategoryCollectionView = {
        let images = Season.allCases.compactMap { $0.image }
        
        let collectionView = CategoryCollectionView(defaultImages: images)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.contentInset.top = 20
        
        return collectionView
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 16
        view.layer.shadowOffset.height = -32
        
        return view
    }()
    
    let coordinator: COCoordinator
    
    init(coordinator: COCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        title = "Choose a season"
        
        navigationController?.navigationBar.prefersLargeTitles = true
                
        collectionView.selectionDelegate = self
    
    }
    
    override func layout() {
        super.layout()
        view.addSubview(collectionView)
//        view.addSubview(shadowView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
//            shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            shadowView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension COSeasonsViewController: CategoryCollectionViewDelegateSelection {
    func collectionView(_ collectionView: CategoryCollectionView, didSelectItemAt index: Int) {
        let season = Season.allCases[index]
        
        coordinator.eventOccured(.items(season))
    }
}

