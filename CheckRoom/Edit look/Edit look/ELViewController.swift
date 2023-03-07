//
//  ELViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit
import Combine

class ELViewController: ViewController {
    
    private var layouted: Bool = false
    
    private var nextBarButton: UIBarButtonItem!
        
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
        
        guard !layouted else {
            return
        }
        
        topCollectionView.itemSize = CGSize(width: topCollectionView.bounds.width * 0.55,
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
        
        if let currentTopWearIndex = topCollectionView.items.firstIndex(where: { $0.image?.pngData() == outfit.topWear.image?.pngData() }) {
            
            topCollectionView.scrollTo(index: currentTopWearIndex)
        }
        
        if let currentBottomWearIndex = bottomCollectionView.items.firstIndex(where: { $0.image?.pngData() == outfit.bottomWear.image?.pngData() }) {
            bottomCollectionView.scrollTo(index: currentBottomWearIndex)
        }

        if let currentShoesIndex = shoesCollectionView.items.firstIndex(where: { $0.image?.pngData() == outfit.shoes.image?.pngData() }) {
            shoesCollectionView.scrollTo(index: currentShoesIndex)
        }
        
        
        self.layouted = true
    }
    
    
    override func setup() {
        super.setup()
        
        view.clipsToBounds = true
        navigationItem.largeTitleDisplayMode = .never
        
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
        
        self.nextBarButton = nextBarButton
        
        var nextButtonEnabledPublisher: AnyPublisher<Bool, Never> {
            return Publishers.CombineLatest3(topCollectionView.$isScrolling,
                                             bottomCollectionView.$isScrolling,
                                             shoesCollectionView.$isScrolling)
            .compactMap { top, bottom, shoes in
                !top && !bottom && !shoes
            }
            .eraseToAnyPublisher()
        }
        
        nextButtonEnabledPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: nextBarButton)
            .store(in: &cancellables)
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        longPressGesture.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressGesture)
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
        guard nextBarButton.isEnabled else {
            return
        }

        let updateHandler: (Outfit) -> Void = { outfit in
            outfit.topWear = self.topCollectionView.selectedItem as? TopWear
            outfit.bottomWear = self.bottomCollectionView.selectedItem as? BottomWear
            outfit.shoes = self.shoesCollectionView.selectedItem as? Shoes
        }
        
        let outfitCopy = outfit.getCopy()
        updateHandler(outfitCopy)
        
        let outfitView = outfitCopy.createPreview()
        
        coordinator.eventOccured(
            .preview(outfit: self.outfit,
                     outfitView: outfitView,
                     updateHandler: updateHandler)
        )
    }
    
    private var selectedWear: Wear?
    
    private var selectedCell: ItemsCollectionViewCell?
    
    private var cellImageView: UIImageView? {
        return selectedCell?.imageView
    }
    
    private var selectedItemPosition = CGPoint()
    
    private var movedImageView: UIImageView?
    
    private var initialTouchPosition = CGPoint()
    
    private var deleteImageView: UIImageView?
    
    
    @objc
    private func longPressed(_ recognizer: UILongPressGestureRecognizer) {
        
        guard nextBarButton.isEnabled else {
            return
        }

        let touchLocation = recognizer.location(in: view)

        switch recognizer.state {
        case .began:
            
            var collectionView: ItemsCollectionView? {
                if topCollectionView.contains(touchLocation) { return topCollectionView }
                else if bottomCollectionView.contains(touchLocation) { return bottomCollectionView }
                else if shoesCollectionView.contains(touchLocation) { return shoesCollectionView }
                else { return nil }
            }
            

            guard let collectionView = collectionView else {
                return
            }

            guard let indexPath = collectionView.indexPathForItem(at: recognizer.location(in: collectionView)),
                  let cell = collectionView.cellForItem(at: indexPath) as? ItemsCollectionViewCell else {
                return
            }
            
            [topCollectionView, bottomCollectionView, shoesCollectionView]
                .compactMap({ $0 })
                .forEach({ $0.isScrollEnabled = false })

            let wear = collectionView.selectedItem
            
            let imageOriginConvertedToCollectionView = cell.convert(cell.imageView.frame.origin, to: collectionView)
            let imageOriginConvertedToView = collectionView.convert(imageOriginConvertedToCollectionView, to: view)

//            self.cellImageView = cell.imageView
            self.selectedCell = cell
            self.selectedWear = wear
            self.selectedItemPosition = imageOriginConvertedToView
            self.initialTouchPosition = touchLocation

 
            let deleteImageView = UIImageView()
            deleteImageView.image = Icons.delete
            deleteImageView.contentMode = .scaleAspectFit
            
            deleteImageView.alpha = 0
            view.insertSubview(deleteImageView, aboveSubview: topCollectionView)
            deleteImageView.frame.size = CGSize(width: 48, height: 48)
            deleteImageView.center.x = view.center.x
            
            if let statusBarMaxY = view.window?.windowScene?.statusBarManager?.statusBarFrame.maxY {
                deleteImageView.frame.origin.y = statusBarMaxY + 6
            }
            
            UIView.animate(withDuration: 0.2) { deleteImageView.alpha = 1 }
            
            self.deleteImageView = deleteImageView
            
            
            let imageSize = cell.imageView.frame.size

            let newImageView = UIImageView()
            newImageView.image = cell.imageView.image
            newImageView.contentMode = cell.imageView.contentMode
            newImageView.frame.size = imageSize
            newImageView.frame.origin = imageOriginConvertedToView
//            newImageView.frame.origin = collectionView.convert(cell.imageView.frame.origin, to: view)
            newImageView.isUserInteractionEnabled = true
                    
            view.insertSubview(newImageView, aboveSubview: deleteImageView)
            
            self.cellImageView?.isHidden = true
            self.movedImageView = newImageView
            
        case .changed:
    
            let dx = touchLocation.x - self.initialTouchPosition.x
            let dy = touchLocation.y - self.initialTouchPosition.y

            self.movedImageView?.frame.origin = CGPoint(x: self.selectedItemPosition.x + dx,
                                                        y: self.selectedItemPosition.y + dy)
                        
        case .ended:
            
            if let deleteImageView = self.deleteImageView, deleteImageView.contains(touchLocation) {
                
                UIView.animate(withDuration: 0.2) {
                    self.movedImageView?.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.deleteImageView?.alpha = 0
                } completion: { _ in
                    
                    self.movedImageView?.removeFromSuperview()
                    self.deleteImageView?.removeFromSuperview()
                    self.deleteImageView = nil
                    
                    guard let selectedWear = self.selectedWear else {
                        return
                    }
                    
                    let collectionViews = [
                        self.topCollectionView, self.bottomCollectionView, self.shoesCollectionView
                    ].compactMap { $0 }
                    
                    collectionViews.forEach { collectionView in
                        
                        if let itemIndex = collectionView.items.firstIndex(where: { selectedWear == $0 }) {
                            
                            let outfits = DataManager.shared.getOutfits(forSeason: self.outfit.season)
                                .filter {
                                    $0.topWear.isEqual(toWear: selectedWear) ||
                                    $0.bottomWear.isEqual(toWear: selectedWear) ||
                                    $0.shoes.isEqual(toWear: selectedWear)
                                }
                            
                            
                            
                            if outfits.isEmpty {
                                
                                let indexPath = IndexPath(item: itemIndex, section: 0)
                                collectionView.deleteItems(at: [indexPath])
                                DataManager.shared.deleteWear(selectedWear)
                                
                                self.selectedWear = nil
                                self.selectedCell = nil
                                self.movedImageView = nil
                                
                                [self.topCollectionView, self.bottomCollectionView, self.shoesCollectionView]
                                    .compactMap({ $0 })
                                    .forEach({ $0.isScrollEnabled = true })
                                
                            } else {
                                
                                let alert = UIAlertController(title: "Warning!",
                                                              message: "You have outfits with this item!\nAll of them will be deleted!\nAre you sure you want to delete this item?",
                                                              preferredStyle: .alert)
                                
                                let deleteAction = UIAlertAction(title: "Delete",
                                                                 style: .destructive) { _ in
                                    
                                    let shouldPop = outfits.contains(where: { $0.isEqual(toOutfit: self.outfit) })
                                    
                                    outfits.forEach { DataManager.shared.deleteOutfit($0) }
                                    
                                    let indexPath = IndexPath(item: itemIndex, section: 0)
                                    collectionView.deleteItems(at: [indexPath])
                                    DataManager.shared.deleteWear(selectedWear)
                                    
                                    self.selectedWear = nil
                                    self.selectedCell = nil
                                    self.movedImageView = nil
                                    
                                    [self.topCollectionView, self.bottomCollectionView, self.shoesCollectionView]
                                        .compactMap({ $0 })
                                        .forEach({ $0.isScrollEnabled = true })
                                    
                                    if shouldPop {
                                        self.coordinator.pop()
                                    }
                                    
                                }
                                
                                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in

                                    self.cellImageView?.isHidden = false
  
                                    self.selectedWear = nil
                                    self.selectedCell = nil
                                    
                                    [self.topCollectionView, self.bottomCollectionView, self.shoesCollectionView]
                                        .compactMap({ $0 })
                                        .forEach({ $0.isScrollEnabled = true })
                                    
                                }
                                
                                alert.addAction(deleteAction)
                                alert.addAction(cancelAction)
                                
                                
                                self.present(alert, animated: true)
                                
                            }

                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                UIView.animate(withDuration: 0.3) {
                    self.movedImageView?.frame.origin = self.selectedItemPosition
                    self.deleteImageView?.alpha = 0
                } completion: { _ in
                    self.cellImageView?.isHidden = false
                    self.movedImageView?.removeFromSuperview()
                    self.deleteImageView?.removeFromSuperview()
                    
                    self.deleteImageView = nil
                    self.selectedWear = nil
                    self.selectedCell = nil
                    self.movedImageView = nil
                    
                    
                    [self.topCollectionView, self.bottomCollectionView, self.shoesCollectionView]
                        .compactMap({ $0 })
                        .forEach({ $0.isScrollEnabled = true })
                }
                
            }
            
        
            
        default:
            break
        }
                
    }

}
