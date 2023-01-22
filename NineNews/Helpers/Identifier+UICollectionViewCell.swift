//
//  Identifier+UICollectionView.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    static var nibName: String {
        String(describing: self)
    }
    
    static var reuseIdentifier: String {
        return nibName
    }

    static var cellNib: UINib? {
        let bundle = Bundle(for: self)
        
        return UINib(nibName: nibName, bundle: bundle)
    }
}

extension UICollectionView {
    func scrollToTop() {
        setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
}
