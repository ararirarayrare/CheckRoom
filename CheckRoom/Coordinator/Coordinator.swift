//
//  Coordinator.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

protocol Coordinator {
    
    var window: UIWindow? { get }
    
    var navigationController: NavigationController? { get }
    
    func start()
    
}

class MainCoordinator: Coordinator {
    
    enum Event {
        case addItem
    }
    
    private let builder: MainBuilder
    
    var window: UIWindow?
    
    var navigationController: NavigationController?
    
    init(builder: MainBuilder, window: UIWindow?) {
        self.builder = builder
        self.window = window
    }
    
    func eventOccured(_ event: Event) {
        switch event {
        case .addItem:
            let vc = builder.createCamera()
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func start() {
        let vc = builder.createMain(coordinator: self)
        navigationController = NavigationController(rootViewController: vc)
        window?.rootViewController = navigationController
    }
}
