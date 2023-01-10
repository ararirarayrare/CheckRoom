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

class MainCoordinator: Coordinator {
    
    enum Event {
        case addItem
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
            let builder = builder.createAddItemBuilder()
            let coordinator = AddItemCoordinator(builder: builder,
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

class AddItemCoordinator: Coordinator {
    
    enum Event {
        case category, subcatecoryTop, accessory, season, saved, pop
    }
    
    weak var parent: Coordinator?
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    let builder: AddItemBuilder
    
    init(builder: AddItemBuilder, navigationController: NavigationController?) {
        self.window = navigationController?.view.window
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .category:
            let vc = builder.createCategory(coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
        case .subcatecoryTop:
            let vc = builder.createSubcategory(coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
        case .accessory:
            let vc = builder.createAccessory(coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
        case .season:
            let vc = builder.createSeason(coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
        case .saved:
            let vc = builder.createSaved(coordinator: self)
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overFullScreen
            navigationController?.present(vc, animated: true)
//            navigationController?.pushViewController(vc, animated: true)
        case .pop:
            navigationController?.presentedViewController?.dismiss(animated: false)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func start() {
        let vc = builder.createCamera(coordinator: self)
        navigationController?.pushViewController(vc, animated: false)
    }
    
}
