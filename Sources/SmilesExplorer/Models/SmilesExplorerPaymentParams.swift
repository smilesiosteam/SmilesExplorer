//
//  SmilesExplorerPaymentParams.swift
//  
//
//  Created by Shmeel Ahmad on 19/07/2023.
//

import Foundation
import SmilesUtilities
import SmilesOffers

public struct SmilesExplorerPaymentParams {
    
    public var lifeStyleOffer: BOGODetailsResponseLifestyleOffer?
    public var freeOffer: OfferDO?
    public var themeResources: ThemeResources?
    public var isComingFromSpecialOffer: Bool
    public var isComingFromTreasureChest: Bool
    
}

