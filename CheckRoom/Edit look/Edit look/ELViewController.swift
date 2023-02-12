//
//  ELViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit


class ELViewController: ViewController {
    
    private lazy var topCollectionView = createCollectionView(
        withItems: Array(repeating: UIImage(named: "top-item"), count: 4),
        frame: CGRect(x: 0,
                      y: 120,
                      width: view.bounds.width,
                      height: (view.bounds.height - 120)  * 0.25)
    )
    
    private lazy var bottomCollectionView = createCollectionView(
        withItems: Array(repeating: UIImage(named: "bottom-item"), count: 4),
        frame: CGRect(x: 0,
                      y: topCollectionView.frame.maxY + 4,
                      width: view.bounds.width,
                      height: (view.bounds.height - 120) * 0.4)
    )
    
    private lazy var shoesCollectionView = createCollectionView(
        withItems: Array(repeating: UIImage(named: "shoe-item"), count: 4),
        frame: CGRect(x: 0,
                      y: bottomCollectionView.frame.maxY + 4,
                      width: view.bounds.width,
                      height: (view.bounds.height - 120) * 0.15)
    )
        
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
    }
    
    private func createCollectionView(withItems items: [UIImage?], frame: CGRect) -> ItemsCollectionView {
        let collectionView = ItemsCollectionView(items: items, frame: frame)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }
    
}
