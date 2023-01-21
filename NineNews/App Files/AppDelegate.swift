//
//  AppDelegate.swift
//  NineNews
//
//  Created by Aruna Sairam on 19/1/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupCoordinator()
        coordinator?.start()
        
        return true
    }
    
    private func setupCoordinator() {
        let rootNavigationController = UINavigationController()
        
        coordinator = MainCoordinator(navigationController: rootNavigationController)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootNavigationController
        window?.makeKeyAndVisible()
    }
}

