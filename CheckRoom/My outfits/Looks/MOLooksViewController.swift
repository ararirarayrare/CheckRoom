//
//  MOLooksViewController.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class MOLooksViewController: ViewController {
    
    private var collectionView: TOLooksCollectionView?
    
    let coordinator: MOCoordinator
    
    private let season: Season
    
    init(coordinator: MOCoordinator, season: Season) {
        self.coordinator = coordinator
        self.season = season
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationItem.backButtonDisplayMode = .default
    }
    
    override func setup() {
        super.setup()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = season.title + " season"

        let anotherSeasonBarButton = UIBarButtonItem(title: "Another season",
                                                     style: .plain,
                                                     target: self,
                                                     action: #selector(changeSeasonTapped))
        
        anotherSeasonBarButton.setTitleTextAttributes(
            [
                .font : UIFont.boldSystemFont(ofSize: 16),
                .foregroundColor : UIColor.black
            ],
            for: .normal
        )
        
        navigationItem.rightBarButtonItem = anotherSeasonBarButton
        
        let outfits = DataManager.shared.getOutfits(forSeason: self.season)
        
        guard !outfits.isEmpty else {
            setupOops()
            return
        }
        
        collectionView = TOLooksCollectionView(outfits: outfits)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        longPressGesture.minimumPressDuration = 0.2
                
        collectionView?.addGestureRecognizer(longPressGesture)
        collectionView?.selectionDelegate = self
    }
    
    override func layout() {
        super.layout()
        
        guard let collectionView = collectionView else {
            return
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func changeSeasonTapped() {
        coordinator.eventOccured(.chooseSeason)
    }

    
    @objc
    private func longPressed(_ recognizer: UILongPressGestureRecognizer) {

        guard recognizer.state == .began, let collectionView = collectionView else {
            return
        }
        
        let point = recognizer.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: point),
           let cell = (collectionView.cellForItem(at: indexPath) as? TOLooksCollectionViewCell) {
            
            let outfitView = cell.outfit.createPreview()
            outfitView.layer.cornerRadius = cell.outfitView.layer.cornerRadius
            
            let point = collectionView.convert(cell.frame.origin, to: view)
            
            let originalOrigin = CGPoint(x: point.x + 16, y: point.y + 16)

            let previewViewController = TOLooksPreviewViewController(
                outfitView: outfitView,
                originalRect: CGRect(origin: originalOrigin, size: cell.outfitView.frame.size)
            ) {
                cell.outfitView.isHidden = false
                UIView.animate(withDuration: 0.1) {
                    cell.outfitView.layer.shadowOpacity = 0.2
                }
            }
            
            present(previewViewController, animated: false)
            
            UIView.animate(withDuration: 0.1) {
                cell.outfitView.layer.shadowOpacity = 0
            } completion: { _ in
                cell.outfitView.isHidden = true
                previewViewController.animatePresenting()
            }
        }
        
    }
    
    @objc
    private func createLookTapped() {
        navigationItem.backButtonDisplayMode = .minimal
        (coordinator.parent as? MainCoordinator)?.eventOccured(.createOutfit)
    }
    
    private func setupOops() {
//        navigationItem.backButtonDisplayMode = .minimal
        
        let label = UILabel()
        label.font = .poppinsFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor(red: 114/255, green: 114/255, blue: 114/255, alpha: 1.0)
        label.numberOfLines = 0
        
        label.text = "There are no items in the '\(season.title)' category yet.\n\nCreate it right now!"
        
        
        let createLookButton = UIButton(type: .system)
        createLookButton.translatesAutoresizingMaskIntoConstraints = false
        createLookButton.backgroundColor = .black
        createLookButton.titleLabel?.font = .boldSystemFont(ofSize: 22)
        createLookButton.setTitleColor(.white, for: .normal)
        createLookButton.setTitle("Create a look", for: .normal)
        createLookButton.layer.cornerRadius = 28
        createLookButton.addTarget(self, action: #selector(createLookTapped), for: .touchUpInside)
        
        
        label.translatesAutoresizingMaskIntoConstraints = false
        createLookButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        view.addSubview(createLookButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                           constant: 48),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                            constant: -48),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                       constant: 40),
            
            
            createLookButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -32),
            createLookButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createLookButton.widthAnchor.constraint(equalToConstant: 180),
            createLookButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
}

extension MOLooksViewController: TOLooksCollectionViewDelegateSelection {
    func collectionView(_ collectionView: TOLooksCollectionView, didSelectOutfit outfit: Outfit) {
        coordinator.eventOccured(.preview(outfit))
    }
}
