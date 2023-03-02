//
//  COLookViewController.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit
import Combine

class COItemsViewController: ViewController {
    
    private var missingCategories = [String]()
    
    private var nextBarButton: UIBarButtonItem?
    
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
        
        
        guard !topItems.isEmpty && !bottomItems.isEmpty && !shoes.isEmpty else {
            
            if topItems.isEmpty { missingCategories.append("Top") }
            if bottomItems.isEmpty { missingCategories.append("Bottom") }
            if shoes.isEmpty { missingCategories.append("Shoes") }
            
            
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
        
        self.nextBarButton = nextBarButton
    

        let topCollectionView = ItemsCollectionView(items: topItems)
        let bottomCollectionView = ItemsCollectionView(items: bottomItems)
        let shoesCollectionView = ItemsCollectionView(items: shoes)
        
        var nextButtonEnabledPublisher: AnyPublisher<Bool, Never> {
            return Publishers.CombineLatest3(topCollectionView.$isScrolling,
                                             bottomCollectionView.$isScrolling,
                                             shoesCollectionView.$isScrolling)
            .compactMap { top, bottom, shoes in
                !top && !bottom && !shoes
            }.eraseToAnyPublisher()
        }
        
        nextButtonEnabledPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: nextBarButton)
            .store(in: &cancellables)

        
        self.topCollectionView = topCollectionView
        self.bottomCollectionView = bottomCollectionView
        self.shoesCollectionView = shoesCollectionView
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        longPressGesture.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressGesture)
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
        guard nextBarButton?.isEnabled == true else {
            return
        }
        
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
    
    private var oopsLabel: UILabel?
    private var addItemButton: UIButton?

    private func setupOops() {
        navigationItem.title = "Oops..."
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.largeTitleDisplayMode = .always
        
        let label = UILabel()
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        label.numberOfLines = 0
        
        
        if !self.missingCategories.isEmpty {
            
            var missingCategoriesString = NSMutableAttributedString(string: "")
            
            missingCategories.forEach { category in
                let string = missingCategoriesString.string.isEmpty ? category : ", \(category)"
                let attrString = NSAttributedString(
                    string: string,
                    attributes: [
                        .foregroundColor : UIColor.black,
                        .font : UIFont.boldPoppinsFont(ofSize: 16) ?? .boldSystemFont(ofSize: 16)
                    ]
                )
            
                missingCategoriesString.append(attrString)
            }
            
            let endingString = (self.missingCategories.count == 1) ? " category" : " categories"
            let attrString = NSAttributedString(
                string: endingString
//                attributes: [
//                    .foregroundColor : UIColor.black
//                ]
            )
            missingCategoriesString.append(attrString)
            
            
            let attributedText = NSMutableAttributedString(
                string: "Unfortunately, there are not enough items to create outfit :(\n\nAdd items to the ",
                attributes: [
                    .foregroundColor : UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
                ]
            )
            
            attributedText.append(missingCategoriesString)
            
            let attributedTextEnding = NSAttributedString(
                string: " to create an outfit. Just take a photo and add an item from your gallery!",
                attributes: [
                    .foregroundColor : UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
                ]
            )
            
            attributedText.append(attributedTextEnding)
            
            
            label.attributedText = attributedText
        } else {
            
            label.text = "Unfortunately, you don't have enough items to create a look :(\n\nTake a photo or add an item from your gallery!"
            
        }
        
        
        let addItemButton = UIButton(type: .system)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = .black
        addItemButton.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
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
        
        
        self.oopsLabel = label
        self.addItemButton = addItemButton
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
        
        guard nextBarButton?.isEnabled == true else {
            return
        }

        let touchLocation = recognizer.location(in: view)

        switch recognizer.state {
        case .began:
            
            var collectionView: ItemsCollectionView? {
                if topCollectionView!.contains(touchLocation) {
                    return topCollectionView
                } else if bottomCollectionView!.contains(touchLocation) {
                    return bottomCollectionView
                } else if shoesCollectionView!.contains(touchLocation) {
                    return shoesCollectionView
                } else {
                    return nil
                }
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
            view.insertSubview(deleteImageView, aboveSubview: topCollectionView! )
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
                            
                            let outfits = DataManager.shared.getOutfits(forSeason: self.season)
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
                                
                                if collectionView.items.isEmpty {
                                    
                                    self.navigationItem.rightBarButtonItem = nil
                                    self.topCollectionView?.removeFromSuperview()
                                    self.bottomCollectionView?.removeFromSuperview()
                                    self.shoesCollectionView?.removeFromSuperview()
                                    
                                    self.setupOops()
                                    self.oopsLabel?.alpha = 0
                                    self.addItemButton?.alpha = 0
                                    
                                    
                                    UIView.animate(withDuration: 0.3) {
                                        self.oopsLabel?.alpha = 1
                                        self.addItemButton?.alpha = 1
                                    }
                                    
                                }
                                
                            } else {
                                
                                let alert = UIAlertController(title: "Warning!",
                                                              message: "You have outfits with this item!\nAll of them will be deleted!\nAre you sure you want to delete this item?",
                                                              preferredStyle: .alert)
                                
                                let deleteAction = UIAlertAction(title: "Delete",
                                                                 style: .destructive) { _ in
                                    
//                                    let shouldPop = outfits.contains(where: { $0.isEqual(toOutfit: self.outfit) })

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
                                    
                                    
                                    if collectionView.items.isEmpty {
                                        
                                        self.navigationItem.rightBarButtonItem = nil
                                        self.topCollectionView?.removeFromSuperview()
                                        self.bottomCollectionView?.removeFromSuperview()
                                        self.shoesCollectionView?.removeFromSuperview()
                                        
                                        self.setupOops()
                                        self.oopsLabel?.alpha = 0
                                        self.addItemButton?.alpha = 0
                                        
                                        
                                        UIView.animate(withDuration: 0.3) {
                                            self.oopsLabel?.alpha = 1
                                            self.addItemButton?.alpha = 1
                                        }
                                        
                                    }
                                    
                                    
//                                    if shouldPop {
//                                        self.coordinator.pop()
//                                    }
                                    
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
