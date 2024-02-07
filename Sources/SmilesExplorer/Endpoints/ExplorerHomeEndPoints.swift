//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 07/02/2024.
//

import Foundation

enum ExplorerHomeEndPoints: String, CaseIterable {
    case getSubscriptionBannerDetails
}

extension ExplorerHomeEndPoints {
    var serviceEndPoints: String {
        switch self {
        case .getSubscriptionBannerDetails:
            return "explorer/subscriptionBanner"
        }
    }
}

