//
//  MOCoordinator.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class MOCoordinator: Coordinator {
    
    enum Event {
        case preview(UIImage?), looks(Season), seasons(forEditedLook: UIImage? = nil)
    }
    
    weak var parent: Coordinator?
    
    var children: [Coordinator]?
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    let builder: MOBuilder
    
    init(builder: MOBuilder, navigationController: NavigationController?) {
        self.builder = builder
        self.navigationController = navigationController
        self.window = navigationController?.view.window
    }
    
    func start() {
        let vc = builder.createLooks(forSeason: .current, coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .looks(let season):
            let vc = builder.createLooks(forSeason: season, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
        case .preview(let look):
            let vc = builder.createPreview(forLook: look, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
        case .seasons(let look):
            let vc = builder.createSeasons(forEditedLook: look, coordinator: self)
//            navigationController?.pushViewController(vc, animated: true)
            
            navigationController?.viewControllers.insert(vc, at: 1)
            
            navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    
}
