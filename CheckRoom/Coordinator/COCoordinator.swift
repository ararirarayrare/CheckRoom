//
//  COCoordinator.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class COCoordinator: Coordinator {
    
    enum Event {
        case items(Season), preview(Outfit), saved
    }
    
    weak var parent: Coordinator?
    
    var children: [Coordinator]?
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    let builder: COBuilder
    
    init(builder: COBuilder, navigationController: NavigationController?) {
        self.builder = builder
        self.navigationController = navigationController
        self.window = navigationController?.view.window
    }
    
    func start() {
        let vc = builder.createSeasons(coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .items(let season):
            let vc = builder.createItems(forSeason: season, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .preview(let outfit):
            let vc = builder.createPreview(outfit: outfit, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .saved:
            let vc = builder.createSuccess(title: "Congratulations, your outfit was saved!",
                                           coordinator: self)
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            
            navigationController?.present(vc, animated: true)
        }
    }
    
}
