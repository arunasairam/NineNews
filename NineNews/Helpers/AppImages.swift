//
//  AppImages.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import Foundation
import UIKit

enum AppImages: String {
    case nineNewsLogo = "NineNewsLogo"
    case nineNewsPlaceholder = "NineNewsPlaceholder"
    
    var assetImage: UIImage? {
        return UIImage(named: rawValue)
    }
}

enum SystemImages: String {
    case backwardIcon = "arrow.uturn.backward"
    case forwardIcon = "arrow.uturn.forward"
    case shareIcon = "square.and.arrow.up"
    case websiteIcon = "safari"
    case refreshIcon = "goforward"
    case backIcon = "chevron.left"
    
    var systemImage: UIImage? {
        return UIImage(systemName: rawValue)
    }
}
