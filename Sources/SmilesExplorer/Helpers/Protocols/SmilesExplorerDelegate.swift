//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import Foundation
import SmilesOffers
import SmilesStoriesManager
public enum SmilesExplorerHomeNavigationType {
    case payment, withTextPromo, withQRPromo, freeTicket
}

public protocol SmilesExplorerHomeDelegate {
    
    func proceedToPayment(params: SmilesExplorerPaymentParams, navigationType:SmilesExplorerHomeNavigationType)
    func navigateToFiltersVC(smilesExplorerViewModel: SmilesExplorerHomeUpgradeViewModel?)
    func handleDeepLinkRedirection(redirectionUrl: String)
    
    func navigateToGlobalSearch()
    func navigateToLocation()
    func navigateToRewardPoint(personalizationEventSource: String?)
    func proceedToOfferDetails(offer: OfferDO?)
    func navigateToStoriesWebView(objStory: ExplorerOffer)
}
