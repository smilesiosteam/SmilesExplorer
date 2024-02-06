//
//  SmilesTouristEndpoints.swift
//
//
//  Created by Habib Rehman on 22/01/2024.
//

import Foundation

enum SmilesTouristEndpoints {
    case subscriptionInfo
    case fetchOffersList
    case validateGift
    
    var url: String {
        switch self {
        case .subscriptionInfo:
            return "explorer/subscription"
        case .fetchOffersList:
            return "explorer/offers"
        case .validateGift:
            return "lifestyle/v1/validate-gift-code"
            
        }
    }
}


