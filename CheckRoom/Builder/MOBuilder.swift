//
//  MOBuilder.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class MOBuilder: Builder {
    
    func createLooks(forSeason season: Season, coordinator: MOCoordinator) -> MOLooksViewController {
        let vc = MOLooksViewController(coordinator: coordinator, season: season)
        return vc
    }
    
    func createSeasons(editedOutfit outfit: Outfit? = nil,
                       coordinator: MOCoordinator) -> MOSeasonsViewController {
        
        let vc = MOSeasonsViewController(coordinator: coordinator,
                                         editedOutfit: outfit)
        return vc
    }
    
    func createPreview(forOutfit outfit: Outfit, coordinator: MOCoordinator) -> MOPreviewViewController {
        let vc = MOPreviewViewController(coordinator: coordinator, outfit: outfit)
        return vc
    }
}
