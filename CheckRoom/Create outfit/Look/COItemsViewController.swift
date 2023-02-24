//
//  COLookViewController.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class COItemsViewController: ViewController {
    
    private var topCollectionView: ItemsCollectionView?
    private var bottomCollectionView: ItemsCollectionView?
    private var shoesCollectionView: ItemsCollectionView?
        
    let coordinator: COCoordinator
    let season: Season
    private let dataManager = DataManager.shared

    
    init(season: Season, coordinator: COCoordinator) {
        self.season = season
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let topCollectionView = topCollectionView,
              let bottomCollectionView = bottomCollectionView,
              let shoesCollectionView = shoesCollectionView else {
            return
        }
        
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
        
        view.clipsToBounds = true
                
        navigationItem.largeTitleDisplayMode = .never
        
        let topItems = dataManager.getWear(type: TopWear.self,
                                           forSeason: self.season)
            .filter { $0.category == .undercoat }
        
        let bottomItems = dataManager.getWear(type: BottomWear.self,
                                              forSeason: self.season)
        
        let shoes = dataManager.getWear(type: Shoes.self,
                                        forSeason: self.season)
        
        Season.allCases.forEach({ print(dataManager.getWear(type: Shoes.self, forSeason: $0).count) })
        
        guard !topItems.isEmpty && !bottomItems.isEmpty && !shoes.isEmpty else {
            setupOops()
            return
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
    

        let topCollectionView = ItemsCollectionView(items: topItems)
        let bottomCollectionView = ItemsCollectionView(items: bottomItems)
        let shoesCollectionView = ItemsCollectionView(items: shoes)
        
        
        self.topCollectionView = topCollectionView
        self.bottomCollectionView = bottomCollectionView
        self.shoesCollectionView = shoesCollectionView
    }
    
    override func layout() {
        super.layout()
        
        if let topCollectionView = topCollectionView,
           let bottomCollectionView = bottomCollectionView,
           let shoesCollectionView = shoesCollectionView {
            
            
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
    }

    
    @objc
    private func nextTapped() {
        let outfit = Outfit(season: season)

        outfit.topWear = topCollectionView?.selectedItem as? TopWear
        outfit.bottomWear = bottomCollectionView?.selectedItem as? BottomWear
        outfit.shoes = shoesCollectionView?.selectedItem as? Shoes
        
        coordinator.eventOccured(.preview(outfit))
    }
    
    @objc
    private func addItemTapped() {
        (coordinator.parent as? MainCoordinator)?.eventOccured(.addItem)
    }

    private func setupOops() {
        navigationItem.title = "Oops..."
        navigationItem.backButtonDisplayMode = .minimal
        
        let label = UILabel()
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        label.numberOfLines = 0
        
        label.text = "Unfortunately, you don't have enough items to create a look :(\n\nTake a photo or add an item from your gallery!"
        
        
        let addItemButton = UIButton(type: .system)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = .black
        addItemButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        addItemButton.setTitleColor(.white, for: .normal)
        addItemButton.setTitle("Add item", for: .normal)
        addItemButton.layer.cornerRadius = 28
        addItemButton.addTarget(self, action: #selector(addItemTapped), for: .touchUpInside)
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(addItemButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 48),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -48),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: 40),
            
            
            addItemButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            addItemButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addItemButton.widthAnchor.constraint(equalToConstant: 180),
            addItemButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
