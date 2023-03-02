//
//  SceneDelegate.swift
//  CheckRoom
//
//  Created by mac on 09.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
        
        let objcTest = ObjcTest()
        objcTest.testFunc()
        
        let loader = LoaderViewController { [weak self] in
            
            if DataManager.shared.isNewUser {
                let vc = OnboardingPageViewController { [weak self] in
                    DataManager.shared.userHasSeenOnboarding()
                    self?.startApplication()
                }
                
                self?.window?.rootViewController = vc
            } else {
                self?.startApplication()
            }
        
        }
    
        window?.rootViewController = loader
    }
    
    private func startApplication() {
        let builder = MainBuilder()
        let coordinator = MainCoordinator(builder: builder,
                                          window: self.window)
        coordinator.start()
    }
}

