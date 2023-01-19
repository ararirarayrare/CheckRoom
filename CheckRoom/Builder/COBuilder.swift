//
//  COBuilder.swift
//  CheckRoom
//
//  Created by mac on 19.01.2023.
//

import UIKit

class COBuilder: Builder {
    
    func createSeasons(coordinator: COCoordinator) -> COSeasonsViewController {
        let vc = COSeasonsViewController(coordinator: coordinator)
        return vc
    }
    
    func createItems(forSeason season: Season, coordinator: COCoordinator) -> COItemsViewController {
        let vc = COItemsViewController(season: season, coordinator: coordinator)
        return vc
    }
    
    func createPreview(forLook image: UIImage?, coordinator: COCoordinator) -> COPreviewViewController {
        let vc = COPreviewViewController(coordinator: coordinator)
        vc.imageView.image = image
        return vc
    }
}
