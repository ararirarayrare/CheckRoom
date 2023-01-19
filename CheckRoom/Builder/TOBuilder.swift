//
//  TOBuilder.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class TOBuilder: Builder {
    
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
    
}
