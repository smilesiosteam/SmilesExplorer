//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import Foundation
import SmilesOffers
import SmilesStoriesManager
import SmilesFilterAndSort

public enum SmilesExplorerHomeNavigationType {
    case payment, withTextPromo, withQRPromo, freeTicket
}

public protocol SmilesExplorerHomeDelegate {
    
    func proceedToPayment(params: SmilesExplorerPaymentParams, navigationType:SmilesExplorerHomeNavigationType)
    func handleDeepLinkRedirection(redirectionUrl: String)
    
    func navigateToGlobalSearch()
    func navigateToLocation()
    func navigateToRewardPoint(personalizationEventSource: String?)
    func proceedToOfferDetails(offer: OfferDO?)
    func navigateToStoriesWebView(objStory: OfferDO)
    func navigateToExplorerHome()
    func navigateToFilter(categoryId: Int, sortingType: String, previousFiltersResponse: Data?, selectedFilters: [FilterValue]?, filterDelegate: SelectedFiltersDelegate)
    func navigateToSortingVC(sorts: [FilterDO], delegate: SelectedSortDelegate)

}
