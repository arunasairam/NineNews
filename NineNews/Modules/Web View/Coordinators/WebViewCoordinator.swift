//
//  WebViewCoordinator.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import Foundation
import UIKit

class WebViewCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    private let url: URL
    
    init(navigationController: UINavigationController, url: URL) {
        self.navigationController = navigationController
        self.url = url
    }
    
    func start() {
        let viewController = WebViewController()
        let viewModel = WebViewModel(url: url)
        
        viewController.coordinator = self
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}
