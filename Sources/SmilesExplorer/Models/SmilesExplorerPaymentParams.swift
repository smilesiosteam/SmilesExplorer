//
//  SmilesExplorerPaymentParams.swift
//  
//
//  Created by Shmeel Ahmad on 19/07/2023.
//

import Foundation
import SmilesUtilities

public struct SmilesExplorerPaymentParams {
    
    public var lifeStyleOffer: BOGODetailsResponseLifestyleOffer
    public var playerID: String
    public var referralCode: String
    public var hasAttendedSmilesExplorerGame: Bool
    public var appliedPromoCode: BOGOPromoCode?
    public var priceAfterPromo: Double?
    public var themeResources: ThemeResources?
    public var isComingFromSpecialOffer: Bool
    public var isComingFromTreasureChest: Bool
    
}

