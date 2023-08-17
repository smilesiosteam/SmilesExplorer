//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/08/2023.
//

import Foundation

enum SmilesExplorerSectionIdentifier: String {
    
    case topPlaceholder = "TOP_PLACEHOLDER"
    case header = "HEADER"
    case tickets = "TICKETS"
    case exclusiveDeals = "EXCLUSIVE_DEALS"
    case bogoOffers = "BOGO_OFFERS"
    case footer = "FOOTER"
    
}

struct SmilesExplorerSectionData {
    
    let index: Int
    let identifier: SmilesExplorerSectionIdentifier
    
}
