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
    
    override func setup() {
        super.setup()
        
        let topItems = DataManager.shared.getWear(type: TopWear.self,
                                                  forSeason: outfit.season)
        
        topCollectionView = createCollectionView(
            withItems: topItems,
            frame: CGRect(x: 0,
                          y: 120,
                          width: view.bounds.width,
                          height: (view.bounds.height - 120)  * 0.25)
        )
        
        if let currentTopWearIndex = topItems.firstIndex(where: { $0.image?.pngData() == outfit.topWear.image?.pngData() }) {
            topCollectionView.scrollTo(index: currentTopWearIndex)
        }
        
        
        let bottomItems = DataManager.shared.getWear(type: BottomWear.self,
                                                     forSeason: outfit.season)
        
        bottomCollectionView = createCollectionView(
            withItems: bottomItems,
            frame: CGRect(x: 0,
                          y: topCollectionView.frame.maxY + 4,
                          width: view.bounds.width,
                          height: (view.bounds.height - 120) * 0.4)
        )
        
        if let currentBottomWearIndex = bottomItems.firstIndex(where: { $0.image?.pngData() == outfit.bottomWear.image?.pngData() }) {
            bottomCollectionView.scrollTo(index: currentBottomWearIndex)
        }
        
        let shoes = DataManager.shared.getWear(type: Shoes.self,
                                               forSeason: outfit.season)
        
        shoesCollectionView = createCollectionView(
            withItems: shoes,
            frame: CGRect(x: 0,
                          y: bottomCollectionView.frame.maxY + 4,
                          width: view.bounds.width,
                          height: (view.bounds.height - 120) * 0.15)
        )
        
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
        
        view.addSubview(topCollectionView)
        view.addSubview(bottomCollectionView)
        view.addSubview(shoesCollectionView)
    }
    
    @objc
    private func nextTapped() {
        //        let look = UIImage(named: "look-example")
        //
        //        coordinator.eventOccured(.preview(look))
        
        // MARK: - TODO !!!
        
        
        DataManager.shared.updateOutfit {
            self.outfit.topWear = self.topCollectionView.selectedItem as? TopWear
            self.outfit.bottomWear = self.bottomCollectionView.selectedItem as? BottomWear
            self.outfit.shoes = self.shoesCollectionView.selectedItem as? Shoes
        }
        
        coordinator.eventOccured(.preview(outfit))
    }
    
    private func createCollectionView(withItems items: [Wear], frame: CGRect) -> ItemsCollectionView {
        let collectionView = ItemsCollectionView(items: items, frame: frame)
        //        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
}
