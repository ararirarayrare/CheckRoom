//
//  Builder.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

protocol Builder {

}

extension Builder {
    func createSuccess(title: String, coordinator: Coordinator) -> SuccessViewController {
        let vc = SuccessViewController(title: title, coordinator: coordinator)
        return vc
    }
}

class MainBuilder: Builder {
    
    private var aiBuilder: AIBuilder?
    private var coBuilder: COBuilder?
    private var toBuilder: TOBuilder?
    private var moBuilder: MOBuilder?
    
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
    
    func createTOBuilder() -> TOBuilder {
        let builder = TOBuilder()
        self.toBuilder = builder
        return builder
    }
    
    func createMOBuilder() -> MOBuilder {
        let builder = MOBuilder()
        self.moBuilder = builder
        return builder
    }
}
