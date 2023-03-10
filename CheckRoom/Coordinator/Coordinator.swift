//
//  Coordinator.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var parent: Coordinator? { get set }
    
    var children: [Coordinator]? { get set }
    
    var window: UIWindow? { get }
    
    var navigationController: NavigationController? { get }
    
    func start()
    
}

extension Coordinator {
    func pop() {
        navigationController?.presentedViewController?.dismiss(animated: false)
        navigationController?.popToRootViewController(animated: true)
    }
}

class MainCoordinator: Coordinator {
    
    enum Event {
        case addItem, createOutfit, tomorrowOutfit, myOutfits
        
        case editOutfit(Outfit)
        case addItemsTo(Outfit)
    }
    
    private let builder: MainBuilder
    
    weak var parent: Coordinator?
    
    var children: [Coordinator]? = []
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    init(builder: MainBuilder, window: UIWindow?) {
        self.builder = builder
        self.window = window
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .addItem:
            if let coordinator = children?.first(where: { ($0 as? AICoordinator) != nil }) {
                coordinator.start()
            } else {
                let builder = builder.createAIBuilder()
                let coordinator = AICoordinator(builder: builder,
                                                navigationController: navigationController)
                coordinator.parent = self
                coordinator.start()
                
                children?.append(coordinator)
            }
            
        case .createOutfit:
            if let coordinator = children?.first(where: { ($0 as? COCoordinator) != nil }) {
                coordinator.start()
            } else {
                let builder = builder.createCOBuilder()
                let coordinator = COCoordinator(builder: builder,
                                                navigationController: navigationController)
                coordinator.parent = self
                coordinator.start()
                
                children?.append(coordinator)
            }
            
        case .tomorrowOutfit:
            if let coordinator = children?.first(where: { ($0 as? TOCoordinator) != nil }) as? TOCoordinator {
                coordinator.start(withSeason: .current)
            } else {
                let builder = builder.createTOBuilder()
                let coordinator = TOCoordinator(builder: builder,
                                                navigationController: navigationController)
                coordinator.parent = self
                coordinator.start(withSeason: .current)
                
                children?.append(coordinator)
            }
            
        case .myOutfits:
            if let coordinator = children?.first(where: { ($0 as? MOCoordinator) != nil }) as? MOCoordinator {
                coordinator.start(withSeason: .current)
            } else {
                let builder = builder.createMOBuilder()
                let coordinator = MOCoordinator(builder: builder,
                                                navigationController: navigationController)
                coordinator.parent = self
                coordinator.start(withSeason: .current)
                
                children?.append(coordinator)
            }
            
            
        case .editOutfit(let outfit):
            if let coordinator = children?.first(where: { ($0 as? ELCoordinator) != nil }) as? ELCoordinator {
                coordinator.start(withOutfit: outfit)
            } else {
                let builder = builder.createELBuilder()
                let coordinator = ELCoordinator(builder: builder,
                                                navigationController: navigationController)
                coordinator.parent = self
                coordinator.start(withOutfit: outfit)

                children?.append(coordinator)
            }
            
        case .addItemsTo(let outfit):
            if let coordinator = children?.first(where: { ($0 as? ELCoordinator) != nil }) as? ELCoordinator {
                coordinator.eventOccured(.addItems(outfit))
            } else {
                let builder = builder.createELBuilder()
                let coordinator = ELCoordinator(builder: builder,
                                                navigationController: navigationController)
                coordinator.parent = self
//                coordinator.start(withOutfit: outfit)
                coordinator.eventOccured(.addItems(outfit))

                children?.append(coordinator)
            }
        }
    }
    
    func start() {
        let vc = builder.createMain(coordinator: self)
        navigationController = NavigationController(rootViewController: vc)
        navigationController?.modalPresentationStyle = .fullScreen
        navigationController?.modalTransitionStyle = .crossDissolve
//        window?.rootViewController = navigationController
        window?.rootViewController?.present(navigationController!, animated: true)
    }
    
}
