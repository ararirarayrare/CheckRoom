//
//  TOCoordinator.swift
//  CheckRoom
//
//  Created by mac on 15.01.2023.
//

import UIKit

class TOCoordinator: Coordinator {
    
    enum Event {
        case looks(Season), preview(Outfit), saved
    }
    
    weak var parent: Coordinator?
    
    var children: [Coordinator]?
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    let builder: TOBuilder
    
    init(builder: TOBuilder, navigationController: NavigationController?) {
        self.builder = builder
        self.navigationController = navigationController
        self.window = navigationController?.view.window
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .looks(let season):
            let vc = builder.createLooks(forSeason: season, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .preview(let outfit):
            let vc = builder.createPreview(forOutfit: outfit, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
            
        case .saved:
            let vc = builder.createSuccess(title: "Congratulations, your outfit has been saved for tomorrow!",
                                           coordinator: self)
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            navigationController?.present(vc, animated: true)
        }
    }
    
    func start() {
        let vc = builder.createSeasons(coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
