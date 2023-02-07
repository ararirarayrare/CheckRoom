//
//  COLookViewController.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class COItemsViewController: ViewController {
    
    private var topCollectionView: ItemsCollectionView!
    private var bottomCollectionView: ItemsCollectionView!
    private var shoesCollectionView: ItemsCollectionView!
    
    let coordinator: COCoordinator
    
    let season: Season
    
    private let dataManager = DataManager()
    
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
        
        let topItems = dataManager.getWear(type: TopWear.self,
                                           forSeason: self.season)
            .filter { $0.category == .undercoat }
            .compactMap { $0.image }
        
        topCollectionView = ItemsCollectionView(
            items: topItems,
            frame: CGRect(x: 0,
                          y: 120,
                          width: view.bounds.width,
                          height: (view.bounds.height - 120)  * 0.25)
        )
        
        bottomCollectionView = ItemsCollectionView(
            items: Array(repeating: UIImage(named: "bottom-item"), count: 4),
            frame: CGRect(x: 0,
                          y: topCollectionView.frame.maxY + 4,
                          width: view.bounds.width,
                          height: (view.bounds.height - 120) * 0.4)
        )
        
        shoesCollectionView = ItemsCollectionView(
            items: Array(repeating: UIImage(named: "shoe-item"), count: 4),
            frame: CGRect(x: 0,
                          y: bottomCollectionView.frame.maxY + 4,
                          width: view.bounds.width,
                          height: (view.bounds.height - 120) * 0.15)
        )
        
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(topCollectionView)
        view.addSubview(bottomCollectionView)
        view.addSubview(shoesCollectionView)
    }
    
    @objc
    private func nextTapped() {
        let look = UIImage(named: "look-example")
        coordinator.eventOccured(.preview(look))
    }
    
    private func createCollectionView(withItems items: [UIImage?], frame: CGRect) -> ItemsCollectionView {
        let collectionView = ItemsCollectionView(items: items, frame: frame)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
}
