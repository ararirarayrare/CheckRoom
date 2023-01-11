//
//  Builder.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class MainBuilder {
    
    private var aiBuilder: AIBuilder?
    private var coBuilder: COBuilder?
    
    func createMain(coordinator: MainCoordinator) -> MainViewController {
        let vc = MainViewController(coordinator: coordinator)
        return vc
    }
    
    func createAIBuilder() -> AIBuilder {
        let builder = AIBuilder()
        self.aiBuilder = builder
        return builder
    }
    
    func createCOBuilder() -> COBuilder {
        let builder = COBuilder()
        self.coBuilder = builder
        return builder
    }
}

class AIBuilder {
    
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
    
    func createSuccess(coordinator: AICoordinator) -> SuccessViewController {
        let vc = SuccessViewController(title: "Congratulations, the item was saved!",
                                     coordinator: coordinator)
        return vc
    }
}

class COBuilder {
    
    func createSeasons(coordinator: COCoordinator) -> COSeasonsViewController {
        let vc = COSeasonsViewController(coordinator: coordinator)
        return vc
    }
    
    func createLooks(forSeason season: Season, coordinator: COCoordinator) -> COLooksViewController {
        let vc = COLooksViewController(coordinator: coordinator, season: season)
        return vc
    }
    
}
