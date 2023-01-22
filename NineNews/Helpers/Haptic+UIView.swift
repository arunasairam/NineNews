//
//  Haptic+UIView.swift
//  NineNews
//
//  Created by Aruna Sairam on 21/1/2023.
//

import Foundation
import UIKit

struct HapticFeedback {
    static func tapped(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: feedbackStyle)

        generator.impactOccurred()
    }
}
