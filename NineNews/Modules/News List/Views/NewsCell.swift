//
//  NewsCell.swift
//  NineNews
//
//  Created by Aruna Sairam on 20/1/2023.
//

import UIKit

class NewsCell: UICollectionViewCell {
    @IBOutlet private var parentView: UIView!
    @IBOutlet private var mainStackView: UIStackView!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var headline: UILabel!
    @IBOutlet private var abstract: UILabel!
    @IBOutlet private var byLine: UILabel!
    @IBOutlet private var timeView: UIView!
    @IBOutlet private var timeLabel: UILabel!
    
    var viewModel: NewsCellViewModelProvider? {
        didSet {
            setupData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.contentMode = .scaleAspectFit
        imageView.image = AppImages.nineNewsPlaceholder.assetImage
    }
    
    private func setUpUI() {
        setUpAccessibilityIdentifier()
        mainStackView.layer.masksToBounds = true
        mainStackView.layer.cornerRadius = 10
        timeView.roundCorners([.topLeft, .bottomLeft] , radius: 12)
    }
    
    private func setUpAccessibilityIdentifier() {
        imageView.accessibilityIdentifier = AccessibilityIdentifier.thumbnail
        headline.accessibilityIdentifier = AccessibilityIdentifier.headline
        byLine.accessibilityIdentifier = AccessibilityIdentifier.byLine
        abstract.accessibilityIdentifier = AccessibilityIdentifier.abstract
        timeLabel.accessibilityIdentifier = AccessibilityIdentifier.timeElapsed
    }
    
    private func setupData() {
        viewModel?.loadSmallestImageFromAsset { [weak self] data, _, error in
            if let error = error {
                self?.imageView.contentMode = .scaleAspectFit
                self?.imageView.image = AppImages.nineNewsPlaceholder.assetImage
                debugPrint(error.localizedDescription)
            }
            
            if let data = data {
                self?.imageView.image = UIImage(data: data)
                self?.imageView.contentMode = .scaleAspectFill
            }
        }
        
        headline.text = viewModel?.article.headline
        abstract.text = viewModel?.article.theAbstract
        byLine.text = viewModel?.article.byLine
        timeLabel.text = viewModel?.article.date?.elapsedTimeString
    }
    
    private func addShadow() {
        parentView.layer.masksToBounds = false
        parentView.layer.shadowRadius = 3
        parentView.layer.shadowOpacity = 0.5
        parentView.layer.shadowColor = UIColor.systemGray3.cgColor
        parentView.layer.shadowOffset = CGSize(width: 0, height: 6)
    }
}
