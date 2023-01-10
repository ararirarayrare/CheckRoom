//
//  Builder.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class MainBuilder {
    
    private var addItemBuilder: AddItemBuilder?
    
    func createMain(coordinator: MainCoordinator) -> MainViewController {
        let vc = MainViewController(coordinator: coordinator)
        return vc
    }
    
    func createAddItemBuilder() -> AddItemBuilder {
        let builder = AddItemBuilder()
        self.addItemBuilder = builder
        return builder
    }
}

class AddItemBuilder {
    
    func createPreview(coordinator: AddItemCoordinator) -> PreviewViewController {
        let vc = PreviewViewController(coordinator: coordinator)
        return vc
    }
    
    func createCategory(coordinator: AddItemCoordinator) -> CategoryViewController {
        let vc = CategoryViewController(coordinator: coordinator)
        return vc
    }
    
    func createSubcategory(coordinator: AddItemCoordinator) -> SubcategoryViewController {
        let vc = SubcategoryViewController(coordinator: coordinator)
        return vc
    }
    
    func createAccessory(coordinator: AddItemCoordinator) -> AccessoryViewController {
        let vc = AccessoryViewController(coordinator: coordinator)
        return vc
    }
    
    func createSeason(coordinator: AddItemCoordinator) -> SeasonViewController {
        let vc = SeasonViewController(coordinator: coordinator)
        return vc
    }
    
    func createSaved(coordinator: AddItemCoordinator) -> SavedViewController {
        let vc = SavedViewController(title: "Congratulations, the item was saved!",
                                     coordinator: coordinator)
        return vc
    }
}
