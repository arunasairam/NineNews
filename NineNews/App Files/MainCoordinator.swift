//
//  NewListCoordinator.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let newsListCoordinator = NewsListCoordinator(navigationController: navigationController)
        
        childCoordinators.append(newsListCoordinator)
        newsListCoordinator.start()
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
