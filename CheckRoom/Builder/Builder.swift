//
//  Builder.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class MainBuilder {
    
    func createMain(coordinator: MainCoordinator) -> MainViewController {
        let vc = MainViewController(coordinator: coordinator)
        return vc
    }
    
    func createCamera() -> CameraViewController {
        let vc = CameraViewController()
        return vc
    }
}
