//
//  ELCoordinator.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELCoordinator: Coordinator {
    
    enum Event {
        case preview(Outfit), addItems(Outfit), outwear(Outfit), saved
    }
    
    var parent: Coordinator?
    
    var children: [Coordinator]?
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    let builder: ELBuilder
    
    init(builder: ELBuilder, navigationController: NavigationController?) {
        self.builder = builder
        self.navigationController = navigationController
        self.window = navigationController?.view.window
    }
    
    func start() {
        fatalError("Method is not implemented! Use start(withLook:)")
    }
    
    func start(withOutfit outfit: Outfit) {
        let vc = builder.createEdit(outfit: outfit, coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .preview(let outfit):
            let vc = builder.createPreview(outfit: outfit, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .addItems(let outfit):
            let vc = builder.createAddItems(outfit: outfit, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .outwear(let outfit):
            let vc = builder.createOutwear(outfit: outfit, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
        case .saved:
            let vc = builder.createSuccess(title: "Congratulations, the item was saved!",
                                           coordinator: self)
            
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            
            navigationController?.present(vc, animated: true)
        }
    }
    
}
