//
//  COLookViewController.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class TOLooksViewController: ViewController {
    
    private let collectionView: TOLooksCollectionView = {
//        let looks = Array<UIImage?>(repeating: UIImage(named: "look-example"), count: 8)
//        let collectionView = TOLooksCollectionView(looks: looks)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//
        
//        return collectionView
        
        return TOLooksCollectionView(outfits: [])
    }()
    
    let coordinator: TOCoordinator
    
    private let season: Season
    
    init(coordinator: TOCoordinator, season: Season) {
        self.coordinator = coordinator
        self.season = season
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setup() {
        super.setup()
        
        title = season.title + " season"
            
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        longPressGesture.minimumPressDuration = 0.2
                
        collectionView.addGestureRecognizer(longPressGesture)
        
        collectionView.selectionDelegate = self
    }
    
    override func layout() {
        super.layout()
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    @objc
    private func longPressed(_ recognizer: UILongPressGestureRecognizer) {

        guard recognizer.state == .began else {
            return
        }
        
        let point = recognizer.location(in: collectionView)
        
        if let indexPath = collectionView.indexPathForItem(at: point),
           let cell = (collectionView.cellForItem(at: indexPath) as? TOLooksCollectionViewCell) {
            
//            let imageView = cell.imageView
//                        
//            let point = collectionView.convert(cell.frame.origin, to: view)
//            
//            let imageModel = TOLookImageModel(image: imageView.image,
//                                              cornerRadius: 20,
//                                              size: imageView.frame.size,
//                                              origin: CGPoint(x: point.x + 16, y: point.y + 16))
//            
//            let previewViewController = TOLooksPreviewViewController(imageModel: imageModel) {
//                cell.containerView.isHidden = false
//            }
//            
//            present(previewViewController, animated: false)
//            
//            cell.containerView.isHidden = true

        }
        
    }
    
}

extension TOLooksViewController: TOLooksCollectionViewDelegateSelection {
    func collectionView(_ collectionView: TOLooksCollectionView, didSelectOutfit outfit: Outfit) {
        // MARK: - TODO !!!
    }
}
