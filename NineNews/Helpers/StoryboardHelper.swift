//
//  StoryboardHelper.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation
import UIKit

enum Storyboard: String {
    case news
    
    var name: String {
        rawValue.capitalized
    }
}

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
    static func instantiate(from storyboardName: Storyboard) -> Self
}

extension StoryboardIdentifiable where Self: UIViewController {
    
    static var storyboardIdentifier: String {
        String(describing: self)
    }
    
    static func instantiate(from storyboardName: Storyboard) -> Self {
        let storyboard = UIStoryboard(name: storyboardName.name, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier) as! Self
    }
}

extension UIViewController: StoryboardIdentifiable {}
