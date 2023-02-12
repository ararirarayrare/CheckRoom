//
//  ELBuilder.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELBuilder: Builder {
    
    func createEdit(outfit: Outfit, coordinator: ELCoordinator) -> ELViewController {
        let vc = ELViewController(coordinator: coordinator, outfit: outfit)
        return vc
    }
    
    func createPreview(outfit: Outfit, coordinator: ELCoordinator) -> ELPreviewViewController {
        let vc = ELPreviewViewController(coordinator: coordinator, outfit: outfit)
        return vc
    }
    
    func createAddItems(outfit: Outfit, coordinator: ELCoordinator) -> ELAddItemsViewController {
        let vc = ELAddItemsViewController(coordinator: coordinator, outfit: outfit)
        return vc
    }
    
    func createOutwear(outfit: Outfit, coordinator: ELCoordinator) -> ELOutwearViewController {
        let vc = ELOutwearViewController(coordinator: coordinator, outfit: outfit)
        return vc
    }
}
