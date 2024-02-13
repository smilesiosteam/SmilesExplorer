//
//  File.swift
//  
//
//  Created by Habib Rehman on 05/02/2024.
//


import Foundation
import UIKit
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesSharedServices

public enum SmilesTouristConfigrator {
   
    public static func getSmilesTouristHomeVC(dependance: SmilesTouristDependance) -> SmilesExplorerHomeViewController {
        
        let offersUseCase = OffersListUseCase(services: service)
        let subscriptionUseCase = ExplorerSubscriptionUseCase(services: service)
        let filtersUseCase = FiltersUseCase()
        let wishListUseCase = WishListUseCase()
        let rewardPointUseCase = RewardPointUseCase()
        let sectionsUseCase = SectionsUseCase()
        let subscriptionBannerUseCase = SubscriptionBannerUseCase(services: service)
        
        let viewModel = SmilesTouristHomeViewModel(categoryId: dependance.categoryId, offerUseCase: offersUseCase, subscriptionUseCase: subscriptionUseCase, filtersUseCase: filtersUseCase, sectionsUseCase: sectionsUseCase,rewardPointUseCase: rewardPointUseCase,wishListUseCase: wishListUseCase,subscriptionBannerUseCase:subscriptionBannerUseCase)
        
        let smilesExplorerHomeViewController = SmilesExplorerHomeViewController.init()
        smilesExplorerHomeViewController.hidesBottomBarWhenPushed = true
        
        smilesExplorerHomeViewController.viewModel = viewModel
        smilesExplorerHomeViewController.delegate = dependance.delegate
        
        return smilesExplorerHomeViewController
    }
    
    static func getExplorerListingVC(dependence: ExplorerOffersListingDependance) -> ExplorerOffersListingViewController {
        
        let offersUseCase = OffersListUseCase(services: service)
        let viewModel = ExplorerOffersListingViewModel(offerUseCase: offersUseCase)
        let viewController = ExplorerOffersListingViewController(viewModel: viewModel, dependencies: dependence)
        return viewController
        
    }
    
    static func getFAQsVC() -> FAQsViewController {
        
        let faqsUseCase = FAQsUseCase()
        let viewModel = ExplorerFAQsViewModel(faqsUseCase: faqsUseCase)
        let viewController = FAQsViewController(viewModel: viewModel)
        return viewController
        
    }
    
    static var service: SmilesTouristServiceHandler {
        return .init(repository: repository)
    }
    
    static var network: Requestable {
        NetworkingLayerRequestable(requestTimeOut: 60)
    }
    
    static var repository: SmilesTouristServiceable {
        SmilesTouristRepository(networkRequest: network)
    }
    
}

