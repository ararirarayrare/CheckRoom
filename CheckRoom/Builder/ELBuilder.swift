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
    
    func createPreview(outfit: Outfit,
                       outfitView: OutfitView,
                       coordinator: ELCoordinator,
                       updateHandler: @escaping (Outfit) -> Void) -> ELPreviewViewController {
        
        let vc = ELPreviewViewController(coordinator: coordinator,
                                         outfit: outfit,
                                         outfitView: outfitView,
                                         updateHandler: updateHandler)
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
    
    func createAccessoryCategories(outfit: Outfit,
                                   coordinator: ELCoordinator) -> ELAccessoryCategoriesViewController {
        let vc = ELAccessoryCategoriesViewController(coordinator: coordinator, outfit: outfit)
        return vc
    }
    
    func createAccessory(category: Accessory.Category,
                         outfit: Outfit,
                         coordinator: ELCoordinator) -> ELAccessoryViewController {
        let vc = ELAccessoryViewController(coordinator: coordinator,
                                           outfit: outfit,
                                           accessoryCategory: category)
        return vc
    }
}
