//
//  AICoordinator.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class AICoordinator: Coordinator {
    
    enum Event {
        case category(image: UIImage?),
             subcategoryTop(image: UIImage?),
             accessory(image: UIImage?),
             season(wear: Wear),
             saved
    }
    
    weak var parent: Coordinator?
    
    var children: [Coordinator]?
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    let builder: AIBuilder
    
    init(builder: AIBuilder, navigationController: NavigationController?) {
        self.window = navigationController?.view.window
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .category(let image):
            let vc = builder.createCategory(coordinator: self, image: image)
            navigationController?.pushViewController(vc, animated: true)
            
        case .subcategoryTop(let image):
            let vc = builder.createSubcategory(coordinator: self, image: image)
            navigationController?.pushViewController(vc, animated: true)
            
        case .accessory(let image):
            let vc = builder.createAccessory(coordinator: self, image: image)
            navigationController?.pushViewController(vc, animated: true)
            
        case .season(let wear):
            let vc = builder.createSeason(coordinator: self, wear: wear)
            navigationController?.pushViewController(vc, animated: true)
            
        case .saved:
            let vc = builder.createSuccess(title: "Congratulations, the item was saved!",
                                           coordinator: self)
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            
            navigationController?.present(vc, animated: true)
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func start() {
        let vc = builder.createPreview(coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
