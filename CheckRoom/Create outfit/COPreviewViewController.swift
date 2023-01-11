//
//  COPreviewViewController.swift
//  CheckRoom
//
//  Created by mac on 11.01.2023.
//

import UIKit

class COPreviewViewController: ViewController {
    
    let coordinator: COCoordinator
    
    init(coordinator: COCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
