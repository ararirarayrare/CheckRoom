//
//  Builder.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class MainBuilder {
    
    private var aiBuilder: AIBuilder?
    private var toBuilder: TOBuilder?
    
    func createMain(coordinator: MainCoordinator) -> MainViewController {
        let vc = MainViewController(coordinator: coordinator)
        return vc
    }
    
    func createAIBuilder() -> AIBuilder {
        let builder = AIBuilder()
        self.aiBuilder = builder
        return builder
    }
    
    func createTOBuilder() -> TOBuilder {
        let builder = TOBuilder()
        self.toBuilder = builder
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
    
    func createSuccess(coordinator: Coordinator) -> SuccessViewController {
        let vc = SuccessViewController(title: "Congratulations, the item was saved!",
                                     coordinator: coordinator)
        return vc
    }
}

class TOBuilder {
    
    func createSeasons(coordinator: TOCoordinator) -> TOSeasonsViewController {
        let vc = TOSeasonsViewController(coordinator: coordinator)
        return vc
    }
    
    func createLooks(forSeason season: Season, coordinator: TOCoordinator) -> TOLooksViewController {
        let vc = TOLooksViewController(coordinator: coordinator, season: season)
        return vc
    }
    
    func createPreview(forLook image: UIImage?, coordinator: TOCoordinator) -> TOPreviewViewController {
        let vc = TOPreviewViewController(coordinator: coordinator)
        vc.imageView.image = image
        return vc
    }
    
    func createSuccess(coordinator: Coordinator) -> SuccessViewController {
        let vc = SuccessViewController(title: "Congratulations, your outfit has been saved for tomorrow!",
                                     coordinator: coordinator)
        return vc
    }
    
}
