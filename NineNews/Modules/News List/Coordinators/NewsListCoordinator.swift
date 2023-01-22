//
//  NewsListCoordinator.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation
import UIKit

class NewsListCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = NewsListViewController.instantiate(from: .news)
        let viewModel = NewsListViewModel()
        
        viewController.coordinator = self
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showWebViewController(with url: URL) {
        let webCoordinator = WebViewCoordinator(navigationController: navigationController, url: url)
       
        webCoordinator.start()
    }
    
    func showAlert(title: String, message: String, onRetry: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: onRetry)
        
        alertController.addAction(okAction)
        
        if onRetry != nil {
            alertController.addAction(retryAction)
        }
        
        navigationController.present(alertController, animated: true)
    }
}
