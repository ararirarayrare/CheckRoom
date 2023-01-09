//
//  ViewController.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
}

class NavigationController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        navigationBar.barTintColor = .black
        navigationBar.tintColor = .black
        
    }
    
    
}
