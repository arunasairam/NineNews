//
//  AppColors.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import Foundation
import UIKit

enum AppColors: String {
    case accentColor = "AccentColor"
    case sortingMenuColor = "SortingMenuColor"
    case progressBarColor = "ProgressBarColor"
    case progressBarTrackColor = "ProgressBarTrackColor"
    
    var color: UIColor? {
        return UIColor(named: rawValue)
    }
}
