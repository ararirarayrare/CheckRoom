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
    
    func createSeasons(forEditedLook look: UIImage? = nil,
                       coordinator: MOCoordinator) -> MOSeasonsViewController {
        
        let vc = MOSeasonsViewController(coordinator: coordinator, editedLook: look)
        return vc
    }
    
    func createPreview(forLook image: UIImage?, coordinator: MOCoordinator) -> MOPreviewViewController {
        let vc = MOPreviewViewController(coordinator: coordinator)
        vc.imageView.image = image
        return vc
    }
}
