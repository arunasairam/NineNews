//
//  CustomCollectionViewFlowLayout.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import Foundation
import UIKit

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var minColumnWidth: CGFloat
    private var cellHeight: CGFloat
    
    init(minColumnWidth: CGFloat, cellHeight: CGFloat) {
        self.minColumnWidth = minColumnWidth
        self.cellHeight = cellHeight
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.minColumnWidth = 300
        self.cellHeight = 260
        super.init(coder: coder)
    }
    
    override func prepare() {
        let minColumnWidth: CGFloat = minColumnWidth
        let availableWidth: CGFloat = collectionView?.bounds.inset(by: sectionInset).width ?? 0
        let maxNumColumns: CGFloat = (availableWidth / minColumnWidth).rounded(.down)
        let cellWidth = ((availableWidth / maxNumColumns) - minimumInteritemSpacing) .rounded(.down)
        let cellHeight: CGFloat = cellHeight
        
        itemSize = CGSize(width: cellWidth, height: cellHeight)
    }
}
