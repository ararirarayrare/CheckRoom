//
//  ELOutwearViewController.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELOutwearViewController: ViewController {
    
    private var collectionView: ItemsCollectionView?
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.backgroundColor = .black
        button.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Save", for: .normal)
        
        button.layer.cornerRadius = 28
        
        return button
    }()
    
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
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.itemSize = CGSize(width: collectionView.bounds.width * 0.65,
                                            height: collectionView.bounds.height)
        collectionView.spacing = 0
        collectionView.itemsAligment = .top
    }
    
    override func setup() {
        super.setup()
        
        view.clipsToBounds = true
        navigationItem.largeTitleDisplayMode = .never
        
        let outwearItems = DataManager.shared.getWear(type: TopWear.self,
                                                      forSeason: outfit.season)
            .filter { $0.category == .outwear }
        
        guard !outwearItems.isEmpty  else {
            setupOops()
            return
        }
        
        collectionView = ItemsCollectionView(items: outwearItems)
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        longPressGesture.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressGesture)
    }
    
    override func layout() {
        super.layout()
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 140),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                   multiplier: 0.4),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
//                                               constant: 32),
//            collectionView.bottomAnchor.constraint(equalTo: saveButton.topAnchor,
//                                                   constant: -32)
        ])
    }
    
    @objc
    private func saveTapped() {
        DataManager.shared.updateOutfit {
            self.outfit.outwear = self.collectionView?.selectedItem as? TopWear
        }
        
        coordinator.eventOccured(.saved)
    }
    
    @objc
    private func addItemTapped() {
        (coordinator.parent as? MainCoordinator)?.eventOccured(.addItem)
    }
    
    private var oopsLabel: UILabel?
    private var addItemButton: UIButton?
    
    private func setupOops() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = "Oops..."
        navigationItem.largeTitleDisplayMode = .always
        
        let label = UILabel()
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        label.numberOfLines = 0
        
        label.text = "There are no outwear items in the '\(outfit.season.title)' category yet.\n\nTake a photo or add an item from your gallery!"
        
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
        
        guard collectionView?.isScrolling == false else {
            return
        }

        let touchLocation = recognizer.location(in: view)

        switch recognizer.state {
        case .began:

            guard let collectionView = self.collectionView else {
                return
            }

            guard let indexPath = collectionView.indexPathForItem(at: recognizer.location(in: collectionView)),
                  let cell = collectionView.cellForItem(at: indexPath) as? ItemsCollectionViewCell else {
                return
            }
            
            collectionView.isScrollEnabled = false

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
            view.insertSubview(deleteImageView, aboveSubview: collectionView)
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
                    
                    self.movedImageView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    self.movedImageView?.center = deleteImageView.center
                    self.movedImageView?.alpha = 0
                    
                    self.deleteImageView?.alpha = 0
                } completion: { _ in
                    
                    self.movedImageView?.removeFromSuperview()
                    self.deleteImageView?.removeFromSuperview()
                    self.deleteImageView = nil
                    
                    guard let selectedWear = self.selectedWear,
                          let collectionView = self.collectionView else {
                        return
                    }
                    
                    
//                    collectionViews.forEach { collectionView in
                        
                        if let itemIndex = collectionView.items.firstIndex(where: { selectedWear == $0 }) {
                            
                            let outfits = DataManager.shared.getOutfits(forSeason: self.outfit.season)
                                .filter {
                                    $0.outwear?.isEqual(toWear: selectedWear) ?? false
                                }
                            
                            
                            if outfits.isEmpty {
                                
                                let indexPath = IndexPath(item: itemIndex, section: 0)
                                collectionView.deleteItems(at: [indexPath])
                                DataManager.shared.deleteWear(selectedWear)
                                
                                self.selectedWear = nil
                                self.selectedCell = nil
                                self.movedImageView = nil
                                
                                collectionView.isScrollEnabled = true
                                
                                if collectionView.items.isEmpty {
                                    collectionView.removeFromSuperview()
                                    
                                    self.setupOops()
                                    self.oopsLabel?.alpha = 0
                                    self.addItemButton?.alpha = 0
                                    
                                    
                                    UIView.animate(withDuration: 0.3) {
                                        self.oopsLabel?.alpha = 1
                                        self.addItemButton?.alpha = 1
                                    }
                                }
                                
                            } else {
                                
                                let currentOutfitContainsSelectedAccessory = outfits.contains(where: { $0.isEqual(toOutfit: self.outfit) })
                                
                                let alert = UIAlertController(title: "Warning!",
                                                              message: "You have outfits with this outwear!\nIt will be deleted from all of them! Are you sure you want to continue?",
                                                              preferredStyle: .alert)
                                
                                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                                    
                                    self.selectedCell?.isHidden = false
                                    
                                    self.selectedWear = nil
                                    self.selectedCell = nil
                                    
                                    collectionView.isScrollEnabled = true
                                }
                                
                                let deleteAbsolutelyAction = UIAlertAction(title: "Delete absolutely",
                                                                           style: .destructive) { _ in
                                    
                                    
                                    outfits.forEach { outfit in
                                        DataManager.shared.updateOutfit {
                                            outfit.outwear = nil
                                        }
                                    }

                                    let indexPath = IndexPath(item: itemIndex, section: 0)
                                    collectionView.deleteItems(at: [indexPath])
                                    DataManager.shared.deleteWear(selectedWear)
                                    
                                    self.selectedWear = nil
                                    self.selectedCell = nil
                                    self.movedImageView = nil
                                    
                                    collectionView.isScrollEnabled = true
                                    
                                    if collectionView.items.isEmpty {
                                        collectionView.removeFromSuperview()
                                        
                                        self.setupOops()
                                        self.oopsLabel?.alpha = 0
                                        self.addItemButton?.alpha = 0
                                        
                                        
                                        UIView.animate(withDuration: 0.3) {
                                            self.oopsLabel?.alpha = 1
                                            self.addItemButton?.alpha = 1
                                        }
                                    }
                                }
                                
                                alert.addAction(cancelAction)
                                alert.addAction(deleteAbsolutelyAction)
                                
                                
                                if currentOutfitContainsSelectedAccessory {
                                    
                                    alert.message = "The outfit you are editing contains this accessory! Delete it absolutely or remove only from edited outfit?"
                                    
                                    let removeFromCurrentAction = UIAlertAction(title: "Remove from edited outfit",
                                                                            style: .destructive) { _ in
                                        
                                        DataManager.shared.updateOutfit {
                                            self.outfit.outwear = nil
                                        }

                                        self.coordinator.eventOccured(.saved)
                                    }
                                    
                                    alert.addAction(removeFromCurrentAction)
                                }
                                
                                self.present(alert, animated: true)
                                
                            }

                            
                        }
                        
//                    }
                    
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
                    
                    self.collectionView?.isScrollEnabled = true
                }
                
            }
            
        
            
        default:
            break
        }
                
    }

}
