//
//  AIBuilder.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class AIBuilder: Builder {
    
    func createPreview(coordinator: AICoordinator) -> AIPreviewViewController {
        let vc = AIPreviewViewController(coordinator: coordinator)
        return vc
    }
    
    func createCategory(coordinator: AICoordinator, image: UIImage?) -> AICategoryViewController {
        let vc = AICategoryViewController(coordinator: coordinator, image: image)
        return vc
    }
    
    func createSubcategory(coordinator: AICoordinator, image: UIImage?) -> AISubcategoryViewController {
        let vc = AISubcategoryViewController(coordinator: coordinator, image: image)
        return vc
    }
    
    func createAccessory(coordinator: AICoordinator, image: UIImage?) -> AIAccessoryViewController {
        let vc = AIAccessoryViewController(coordinator: coordinator, image: image)
        return vc
    }
    
    func createSeason(coordinator: AICoordinator, wear: Wear) -> AISeasonViewController {
        let vc = AISeasonViewController(coordinator: coordinator, wear: wear)
        return vc
    }
}

