//
//  File.swift
//  
//
//  Created by Habib Rehman on 22/08/2023.
//

import Foundation

public enum SmilesExplorerEndpoints: String, CaseIterable {
    case subscriptionInfo
    case getExclusiveOffer
    
}

extension SmilesExplorerEndpoints {
    var serviceEndPoints: String {
        switch self {
        case .subscriptionInfo:
            return "explorer/subscription"
        case .getExclusiveOffer:
            return "explorer/offers"
    
        }
    }
}
