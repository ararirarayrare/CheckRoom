//
//  ELBuilder.swift
//  CheckRoom
//
//  Created by mac on 20.01.2023.
//

import UIKit

class ELBuilder: Builder {
    
    func createEdit(look: UIImage?, coordinator: ELCoordinator) -> ELViewController {
        let vc = ELViewController(coordinator: coordinator, outfit: look)
        return vc
    }
    
    func createPreview(look: UIImage?, coordinator: ELCoordinator) -> ELPreviewViewController {
        let vc = ELPreviewViewController(coordinator: coordinator, look: look)
        return vc
    }
    
    func createAddItems(look: UIImage?, coordinator: ELCoordinator) -> ELAddItemsViewController {
        let vc = ELAddItemsViewController(coordinator: coordinator, look: look)
        return vc
    }
    
    func createOutwear(look: UIImage?, coordinator: ELCoordinator) -> ELOutwearViewController {
        let vc = ELOutwearViewController(coordinator: coordinator, look: look)
        return vc
    }
}
