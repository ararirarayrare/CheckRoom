//
//  ELViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit


class ELViewController: ViewController {
    
    private var topCollectionView: ItemsCollectionView!
    
    private var bottomCollectionView: ItemsCollectionView!
    
    private var shoesCollectionView: ItemsCollectionView!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        guard let topCollectionView = topCollectionView,
//              let bottomCollectionView = bottomCollectionView,
//              let shoesCollectionView = shoesCollectionView else {
//            return
//        }
        
        topCollectionView.itemSize = CGSize(width: topCollectionView.bounds.width * 0.65,
                                            height: topCollectionView.bounds.height)
        bottomCollectionView.itemSize = CGSize(width: bottomCollectionView.bounds.width * 0.5,
                                               height: bottomCollectionView.bounds.height)
        shoesCollectionView.itemSize = CGSize(width: shoesCollectionView.bounds.width * 0.45,
                                              height: shoesCollectionView.bounds.height)
        
        topCollectionView.spacing = 0
        bottomCollectionView.spacing = 24
        shoesCollectionView.spacing = 32
        
        topCollectionView.itemsAligment = .bottom
        bottomCollectionView.itemsAligment = .top
        shoesCollectionView.itemsAligment = .top
        
        topCollectionView.possibleHeightDelta = 0
        bottomCollectionView.possibleHeightDelta = 16.0
        shoesCollectionView.possibleHeightDelta = 0.0
    }
    
    override func setup() {
        super.setup()
        
        let topItems = DataManager.shared.getWear(type: TopWear.self,
                                                  forSeason: outfit.season)
            .filter { $0.category == .undercoat }
        
        let bottomItems = DataManager.shared.getWear(type: BottomWear.self,
                                                     forSeason: outfit.season)
        
        let shoes = DataManager.shared.getWear(type: Shoes.self,
                                               forSeason: outfit.season)

        topCollectionView = ItemsCollectionView(items: topItems)
        bottomCollectionView = ItemsCollectionView(items: bottomItems)
        shoesCollectionView = ItemsCollectionView(items: shoes)
        
        if let currentTopWearIndex = topItems.firstIndex(where: { $0.image?.pngData() == outfit.topWear.image?.pngData() }) {
            topCollectionView.scrollTo(index: currentTopWearIndex)
        }
        
        if let currentBottomWearIndex = bottomItems.firstIndex(where: { $0.image?.pngData() == outfit.bottomWear.image?.pngData() }) {
            bottomCollectionView.scrollTo(index: currentBottomWearIndex)
        }

        if let currentShoesIndex = shoes.firstIndex(where: { $0.image?.pngData() == outfit.shoes.image?.pngData() }) {
            shoesCollectionView.scrollTo(index: currentShoesIndex)
        }
        
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
        
        topCollectionView.translatesAutoresizingMaskIntoConstraints = false
        bottomCollectionView.translatesAutoresizingMaskIntoConstraints = false
        shoesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(shoesCollectionView)
        view.addSubview(bottomCollectionView)
        view.addSubview(topCollectionView)
        
        NSLayoutConstraint.activate([
            topCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                      multiplier: 0.36),
            
            
            bottomCollectionView.topAnchor.constraint(equalTo: topCollectionView.bottomAnchor),
            bottomCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomCollectionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor,
                                                         multiplier: 0.47),
            
            
            shoesCollectionView.topAnchor.constraint(equalTo: bottomCollectionView.bottomAnchor),
            shoesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            shoesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            shoesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc
    private func nextTapped() {
        DataManager.shared.updateOutfit {
            self.outfit.topWear = self.topCollectionView.selectedItem as? TopWear
            self.outfit.bottomWear = self.bottomCollectionView.selectedItem as? BottomWear
            self.outfit.shoes = self.shoesCollectionView.selectedItem as? Shoes
        }
        
        coordinator.eventOccured(.preview(outfit))
    }
    
}
