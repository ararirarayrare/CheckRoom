//
//  Coordinator.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

protocol Coordinator: AnyObject {
    
    var parent: Coordinator? { get set }
    
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
        case addItem, createOutfit, tomorrowOutfit
    }
    
    private let builder: MainBuilder
    
    weak var parent: Coordinator?
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    init(builder: MainBuilder, window: UIWindow?) {
        self.builder = builder
        self.window = window
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .addItem:
            let builder = builder.createAIBuilder()
            let coordinator = AICoordinator(builder: builder,
                                                 navigationController: navigationController)
            coordinator.parent = self
            coordinator.start()
            
        case .createOutfit:
            let builder = builder.createCOBuilder()
            let coordinator = COCoordinator(builder: builder,
                                            navigationController: navigationController)
            coordinator.parent = self
            coordinator.start()
            
        case .tomorrowOutfit:
            let builder = builder.createTOBuilder()
            let coordinator = TOCoordinator(builder: builder,
                                            navigationController: navigationController)
            coordinator.parent = self
            coordinator.start()
        }
    }
    
    func start() {
        let vc = builder.createMain(coordinator: self)
        navigationController = NavigationController(rootViewController: vc)
        window?.rootViewController = navigationController
    }
    
}
