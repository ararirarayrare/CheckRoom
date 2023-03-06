//
//  ELAccessoryViewController.swift
//  CheckRoom
//
//  Created by mac on 13.02.2023.
//

import UIKit

class ELAccessoryViewController: ViewController {
    
    private var collectionView: AccessoryCollectionView?
    
    private let addButton = UIButton()
    
    let coordinator: ELCoordinator
    
    let outfit: Outfit
    
    let accessoryCategory: Accessory.Category
    
    init(coordinator: ELCoordinator, outfit: Outfit, accessoryCategory: Accessory.Category) {
        self.coordinator = coordinator
        self.outfit = outfit
        self.accessoryCategory = accessoryCategory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setup() {
        super.setup()
        
        navigationItem.largeTitleDisplayMode = .always
        
        var accessoryTitle = String(describing: accessoryCategory)
        let firstLetter = accessoryTitle.removeFirst().uppercased()
        
        title = firstLetter + accessoryTitle
        
        let accessories = DataManager.shared.getWear(type: Accessory.self,
                                                     forSeason: outfit.season)
            .filter { $0.category == self.accessoryCategory }
        
        guard !accessories.isEmpty else {
            setupOops()
            return
        }
        
        
        addButton.backgroundColor = .black
        addButton.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitle("Add", for: .normal)
        addButton.layer.cornerRadius = 28
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        collectionView = AccessoryCollectionView(accessories: accessories)
        
        switch accessoryCategory {
        case .hat:
            if let hat = outfit.hat,
               let selectedIndex = accessories.firstIndex(where: { $0.isEqual(toWear: hat) }) {
                collectionView?.selectedIndex = selectedIndex
                addButton.setTitle("Select", for: .normal)
            }
        case .jewelery:
            if let jewelery = outfit.jewelery,
               let selectedIndex = accessories.firstIndex(where: { $0.isEqual(toWear: jewelery) }) {
                collectionView?.selectedIndex = selectedIndex
                addButton.setTitle("Select", for: .normal)
            }
        case .scarves:
            if let scraves = outfit.scarves,
               let selectedIndex = accessories.firstIndex(where: { $0.isEqual(toWear: scraves) }) {
                collectionView?.selectedIndex = selectedIndex
                addButton.setTitle("Select", for: .normal)
            }
        case .glasses:
            if let glasses = outfit.glasses,
               let selectedIndex = accessories.firstIndex(where: { $0.isEqual(toWear: glasses) }) {
                collectionView?.selectedIndex = selectedIndex
                addButton.setTitle("Select", for: .normal)
            }
        }
        
        
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
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -32),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 140),
            addButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc
    private func addTapped() {
        
        if let accessory = collectionView?.selectedItem {
            
            DataManager.shared.updateOutfit {
                
                switch self.accessoryCategory {
                case .hat:
                    self.outfit.hat = accessory
                case .glasses:
                    self.outfit.glasses = accessory
                case .scarves:
                    self.outfit.scarves = accessory
                case .jewelery:
                    self.outfit.jewelery = accessory
                }
                
            }
            
            if !DataManager.shared.containsOutfit(outfit) {
                DataManager.shared.save(outfit: outfit)
            }
            
            coordinator.eventOccured(.saved)
        }
        
    }
    
    @objc
    private func addItemTapped() {
        (coordinator.parent as? MainCoordinator)?.eventOccured(.addItem)
    }
    
    private var oopsLabel: UILabel?
    private var addItemButton: UIButton?
    
    private func setupOops() {
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.largeTitleDisplayMode = .always
        
        let label = UILabel()
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        label.numberOfLines = 0
        
        var accessoryTitle = String(describing: accessoryCategory)
        let firstLetter = accessoryTitle.removeFirst().uppercased()
        accessoryTitle = firstLetter + accessoryTitle
        
        label.text = "There are no items in the '\(accessoryTitle)' category yet.\n\nCreate it right now!"
        
        
        let addItemButton = UIButton(type: .system)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.backgroundColor = .black
        addItemButton.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
        addItemButton.setTitleColor(.white, for: .normal)
        addItemButton.setTitle("Create a look", for: .normal)
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
    
    private var selectedAccessory: Accessory?
    
    private var selectedCell: AccessoryCollectionViewCell?
    
//    private var cellImageView: UIImageView? {
//        return selectedCell?.imageView
//    }
    
    private var selectedItemPosition = CGPoint()
    
    private var movedImageView: UIView?
    
    private var initialTouchPosition = CGPoint()
    
    private var deleteImageView: UIImageView?
    
    
    @objc
    private func longPressed(_ recognizer: UILongPressGestureRecognizer) {
        
        let touchLocation = recognizer.location(in: view)
        
        switch recognizer.state {
        case .began:
            
            
            guard let collectionView = collectionView else {
                return
            }
            
            guard let indexPath = collectionView.indexPathForItem(at: recognizer.location(in: collectionView)),
                  let cell = collectionView.cellForItem(at: indexPath) as? AccessoryCollectionViewCell else {
                return
            }
            
            collectionView.isScrollEnabled = false
            
            let wear = cell.accessory
            
            let imageOriginConvertedToCollectionView = cell.convert(cell.containerView.frame.origin, to: collectionView)
            let imageOriginConvertedToView = collectionView.convert(imageOriginConvertedToCollectionView, to: view)
            
            //            self.cellImageView = cell.imageView
            self.selectedCell = cell
            self.selectedAccessory = wear
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
            
            
            let imageSize = cell.containerView.frame.size
            
            let newView = UIView()
            newView.frame.size = imageSize
            newView.frame.origin = imageOriginConvertedToView
            newView.isUserInteractionEnabled = true
            newView.backgroundColor = .white
            newView.layer.cornerRadius = 20
            newView.layer.shadowColor = UIColor.black.cgColor
            newView.layer.shadowRadius = 8
            newView.layer.shadowOpacity = 0.2
            newView.layer.shadowOffset.height = 2
            
            let newImageView = UIImageView()
            newImageView.translatesAutoresizingMaskIntoConstraints = false
            newImageView.image = cell.imageView.image
            newImageView.contentMode = cell.imageView.contentMode
            
            newView.addSubview(newImageView)
            
            NSLayoutConstraint.activate([
                newImageView.leadingAnchor.constraint(equalTo: newView.leadingAnchor,
                                                   constant: 12),
                newImageView.topAnchor.constraint(equalTo: newView.topAnchor,
                                               constant: 12),
                newImageView.trailingAnchor.constraint(equalTo: newView.trailingAnchor,
                                                    constant: -12),
                newImageView.bottomAnchor.constraint(equalTo: newView.bottomAnchor,
                                                  constant: -12),
            ])
//            newImageView.frame.size = imageSize
//            newImageView.frame.origin = imageOriginConvertedToView
            
            
            view.insertSubview(newView, aboveSubview: deleteImageView)
            
            self.selectedCell?.isHidden = true
            self.movedImageView = newView
            
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
                    
                    guard let selectedAccessory = self.selectedAccessory,
                          let collectionView = self.collectionView else {
                        return
                    }
                    
                    if let itemIndex = collectionView.accessories.firstIndex(where: { selectedAccessory == $0 }) {
                        
                        let outfits: [Outfit] = DataManager.shared.getOutfits(forSeason: self.outfit.season)
                            .filter { outfit in
                                
                                switch selectedAccessory.category {
                                case .glasses:
                                    return outfit.glasses?.isEqual(toWear: selectedAccessory) ?? false
                                case .jewelery:
                                    return outfit.jewelery?.isEqual(toWear: selectedAccessory) ?? false
                                case .scarves:
                                    return outfit.scarves?.isEqual(toWear: selectedAccessory) ?? false
                                case .hat:
                                    return outfit.hat?.isEqual(toWear: selectedAccessory) ?? false
                                }
                            }
                        
                        
                        if outfits.isEmpty {
                            
                            let indexPath = IndexPath(item: itemIndex, section: 0)
                            collectionView.deleteItems(at: [indexPath])
                            DataManager.shared.deleteWear(selectedAccessory)
                            
                            self.selectedAccessory = nil
                            self.selectedCell = nil
                            self.movedImageView = nil
                            
                            collectionView.isScrollEnabled = true
                            
                            if collectionView.accessories.isEmpty {
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
                                                          message: "You have outfits with this accessory!\nIt will be deleted from all of them! Are you sure you want to continue?",
                                                          preferredStyle: .alert)
                            
                            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                                
                                self.selectedCell?.isHidden = false
                                
                                self.selectedAccessory = nil
                                self.selectedCell = nil
                                
                                collectionView.isScrollEnabled = true
                            }
                            
                            let deleteAbsolutelyAction = UIAlertAction(title: "Delete absolutely",
                                                                       style: .destructive) { _ in
                                
                                
                                outfits.forEach { outfit in
                                    DataManager.shared.updateOutfit {
                                        switch selectedAccessory.category {
                                        case .glasses:
                                            outfit.glasses = nil
                                        case .jewelery:
                                            outfit.jewelery = nil
                                        case .hat:
                                            outfit.hat = nil
                                        case .scarves:
                                            outfit.scarves = nil
                                        }
                                    }
                                }
                                

                                
                                let indexPath = IndexPath(item: itemIndex, section: 0)
                                collectionView.deleteItems(at: [indexPath])
                                DataManager.shared.deleteWear(selectedAccessory)
                                
                                self.selectedAccessory = nil
                                self.selectedCell = nil
                                self.movedImageView = nil
                                
                                collectionView.isScrollEnabled = true
                                
                                if collectionView.accessories.isEmpty {
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
                                        switch self.accessoryCategory {
                                        case .scarves:
                                            self.outfit.scarves = nil
                                        case .glasses:
                                            self.outfit.glasses = nil
                                        case .jewelery:
                                            self.outfit.jewelery = nil
                                        case .hat:
                                            self.outfit.hat = nil
                                        }
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
                    self.selectedCell?.isHidden = false
                    self.movedImageView?.removeFromSuperview()
                    self.deleteImageView?.removeFromSuperview()
                    
                    self.deleteImageView = nil
                    self.selectedAccessory = nil
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
