//
//  HapticManager.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-21.
//

import Foundation
import UIKit

fileprivate final class HapticManager {
    
    static let shared = HapticManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    
    private init() {}
}

// MARK: - Methods
extension HapticManager {
    
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        feedback.notificationOccurred(notification)
    }
}

func haptic(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
    
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.hapticsEnabled) {
        HapticManager.shared.trigger(notification)
    }
}
