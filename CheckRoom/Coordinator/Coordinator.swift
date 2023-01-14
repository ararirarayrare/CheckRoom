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
    
    func pop()
}

extension Coordinator {
    func pop() {
        navigationController?.presentedViewController?.dismiss(animated: false)
        navigationController?.popToRootViewController(animated: true)
    }
}

class MainCoordinator: Coordinator {
    
    enum Event {
        case addItem, tomorrowOutfit
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

class AICoordinator: Coordinator {
    
    enum Event {
        case category, subcatecoryTop, accessory, season, saved
    }
    
    weak var parent: Coordinator?
    
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
            let vc = builder.createSuccess(coordinator: self)
            vc.modalTransitionStyle = .coverVertical
            vc.modalPresentationStyle = .overFullScreen
            navigationController?.present(vc, animated: true)
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func start() {
        let vc = builder.createPreview(coordinator: self)
        navigationController?.pushViewController(vc, animated: false)
    }
    
}


class TOCoordinator: Coordinator {
    
    enum Event {
        case looks(Season), preview(UIImage?), saved
    }
    
    var parent: Coordinator?
    
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
        case .preview(let image):
            let vc = builder.createPreview(forLook: image, coordinator: self)
            navigationController?.pushViewController(vc, animated: true)
            
            
        case .saved:
            let vc = builder.createSuccess(coordinator: self)
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
