//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/09/2023.
//

import Foundation

enum SmilesExplorerSubscriptionUpgradeSectionIdentifier: String {
    
    case topPlaceholder = "TOP_PLACEHOLDER"
    case upgradeBanner = "UPGRADE_BANNER"
    case stories = "STORIES"
    case offerListing = "OFFER_LISTING"
    
}

struct SmilesExplorerSubscriptionUpgradeSectionData {
    
    let index: Int
    let identifier: SmilesExplorerSubscriptionUpgradeSectionIdentifier
    
}
