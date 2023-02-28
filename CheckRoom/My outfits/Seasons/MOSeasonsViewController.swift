//
//  MOSeasonsViewController.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class MOSeasonsViewController: ViewController {
    
    private let collectionView: CategoryCollectionView = {
        let images = Season.allCases.compactMap { $0.image }
        
        let collectionView = CategoryCollectionView(defaultImages: images)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.contentInset.top = 20
        
        return collectionView
    }()
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 16
        view.layer.shadowOffset.height = -32
        
        return view
    }()
    
    private var saveButton: UIButton?
    
    let coordinator: MOCoordinator
    
    private let editedOutfit: Outfit?
    
    private var isEditingOutfit: Bool {
        return editedOutfit != nil
    }
    
    init(coordinator: MOCoordinator, editedOutfit outfit: Outfit? = nil) {
        self.coordinator = coordinator
        self.editedOutfit = outfit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        title = "Choose a season"
        
        navigationItem.largeTitleDisplayMode = .always
        
        if let outfit = editedOutfit, isEditingOutfit {
            collectionView.activeImages = Season.allCases.map { $0.imageActive }
            //MARK: - REDO!!!
            collectionView.selectedItems = [outfit.season.rawValue]
            
            saveButton = UIButton()
            saveButton?.translatesAutoresizingMaskIntoConstraints = false
            saveButton?.backgroundColor = .black
            saveButton?.titleLabel?.font = .semiBoldPoppinsFont(ofSize: 20)
            saveButton?.setTitleColor(.white, for: .normal)
            saveButton?.setTitle("Save", for: .normal)
            saveButton?.layer.cornerRadius = 28

            saveButton?.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
            
        } else {
            collectionView.selectionDelegate = self
        }
        
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if isEditingOutfit {
            view.addSubview(shadowView)
            
            NSLayoutConstraint.activate([
                shadowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                shadowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                shadowView.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        if let saveButton = saveButton {
            view.addSubview(saveButton)
            
            NSLayoutConstraint.activate([
                saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                   constant: -32),
                saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                saveButton.widthAnchor.constraint(equalToConstant: 140),
                saveButton.heightAnchor.constraint(equalToConstant: 56)
            ])
        }
    }
    
    @objc
    private func saveTapped() {
        guard let outfit = editedOutfit, isEditingOutfit else {
            return
        }
        //MARK: - REDO!!!
        let newSeason = Season.allCases[collectionView.selectedItems.first!]
        
        DataManager.shared.updateOutfit {
            outfit.season = newSeason
        }
        
        let alert = UIAlertController(title: "Attention!",
                                      message: "All items from this outfit were moved to a new season!",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.coordinator.eventOccured(.saved)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true)
        
//        coordinator.eventOccured(.saved)
    }
    
}

extension MOSeasonsViewController: CategoryCollectionViewDelegateSelection {
    func collectionView(_ collectionView: CategoryCollectionView, didSelectItemAt index: Int) {
        
        guard !isEditingOutfit else {
            return
        }
        
        let season = Season.allCases[index]
        
        coordinator.start(withSeason: season)
    }
}
