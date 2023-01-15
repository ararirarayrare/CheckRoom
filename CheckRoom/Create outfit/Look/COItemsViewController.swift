//
//  COLookViewController.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class COItemsViewController: ViewController {
    
    private lazy var topCollectionView = createCollectionView(withItems: [])
    
    private lazy var bottomCollectionView = createCollectionView(withItems: [])
    
    private lazy var shoesCollectionView = createCollectionView(withItems: [])
    
    
    let coordinator: COCoordinator
    
    let season: Season
    
    init(season: Season, coordinator: COCoordinator) {
        self.season = season
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        
        let nextBarButton = UIBarButtonItem(title: "Next",
                                            style: .plain,
                                            target: self,
                                            action: #selector(nextTapped))
        nextBarButton.setTitleTextAttributes(
            [
                .font : UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor : UIColor.black
            ],
            for: .normal
        )
        
        navigationItem.rightBarButtonItem = nextBarButton
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(topCollectionView)
        view.addSubview(bottomCollectionView)
        view.addSubview(shoesCollectionView)
        
        
        NSLayoutConstraint.activate([
            topCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                      multiplier: 0.25),
            
            
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCollectionView.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor),
            bottomCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                         multiplier: 0.5),
            
            
            shoesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoesCollectionView.topAnchor.constraint(equalTo: bottomCollectionView.bottomAnchor),
            shoesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                        multiplier: 0.1)
        ])
    }
    
    @objc
    private func nextTapped() {
        let look = UIImage(named: "look-example")
        coordinator.eventOccured(.preview(look))
    }
    
    private func createCollectionView(withItems items: [UIImage?]) -> COItemsCollectionView {
        let collectionView = COItemsCollectionView(items: items)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
}
