//
//  MOCoordinator.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class MOCoordinator: Coordinator {
    
    enum Event {
        case preview(Outfit),
             looks(Season),
             chooseSeason,
             changeSeason(forOutfit: Outfit),
             saved, deleted
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
    
    func start() { }
    
    func start(withSeason season: Season) {
        let vc = builder.createLooks(forSeason: season, coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .looks(let season):
            let vc = builder.createLooks(forSeason: season, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .preview(let outfit):
            let vc = builder.createPreview(forOutfit: outfit, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .chooseSeason:
            let vc = builder.createSeasons(coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .changeSeason(let outfit):
            let vc = builder.createSeasons(editedOutfit: outfit,
                                           coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .saved:
            let vc = builder.createSuccess(title: "Congratulations, the item was saved!",
                                           coordinator: self)
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            
            navigationController?.present(vc, animated: true)
            
        case .deleted:
            let vc = builder.createSuccess(title: "Success!\n The outfit was deleted!",
                                           coordinator: self)
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            
            navigationController?.present(vc, animated: true)
        }
    }
    
    
}
