//
//  COLookViewController.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class COLooksViewController: ViewController {
    
    private let collectionView: COLooksCollectionView = {
        let looks = Array<UIImage?>(repeating: nil, count: 8)
        let collectionView = COLooksCollectionView(looks: looks)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let coordinator: COCoordinator
    
    private let season: Season
    
    init(coordinator: COCoordinator, season: Season) {
        self.coordinator = coordinator
        self.season = season
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setup() {
        super.setup()
        
        title = season.title + " season"
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}
