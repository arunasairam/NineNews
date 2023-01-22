//
//  CornerRadius+UIView.swift
//  NineNews
//
//  Created by Aruna Sairam on 22/1/2023.
//

import Foundation
import UIKit

extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
        
        var cornerMask = CACornerMask()
        
        if corners.contains(.topLeft) {
            cornerMask.insert(.layerMinXMinYCorner)
        }
        if corners.contains(.topRight) {
            cornerMask.insert(.layerMaxXMinYCorner)
        }
        if corners.contains(.bottomLeft) {
            cornerMask.insert(.layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }
        
        layer.maskedCorners = cornerMask
    }
}
