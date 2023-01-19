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
    
    func createCategory(coordinator: AICoordinator) -> AICategoryViewController {
        let vc = AICategoryViewController(coordinator: coordinator)
        return vc
    }
    
    func createSubcategory(coordinator: AICoordinator) -> AISubcategoryViewController {
        let vc = AISubcategoryViewController(coordinator: coordinator)
        return vc
    }
    
    func createAccessory(coordinator: AICoordinator) -> AIAccessoryViewController {
        let vc = AIAccessoryViewController(coordinator: coordinator)
        return vc
    }
    
    func createSeason(coordinator: AICoordinator) -> AISeasonViewController {
        let vc = AISeasonViewController(coordinator: coordinator)
        return vc
    }
}

