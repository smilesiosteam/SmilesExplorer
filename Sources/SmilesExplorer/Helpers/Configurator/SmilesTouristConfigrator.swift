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
import SmilesOffers

public enum SmilesTouristConfigrator {
    
    //MARK: -  Smiles Tourist UnSubscribed HomeVC
    public static func getSmilesTouristHomeVC(dependance: SmilesTouristDependance,navigationDelegate:SmilesExplorerHomeDelegate) -> SmilesExplorerHomeViewController {

        let offersUseCase = OffersListUseCase(services: service)
        let subscriptionUseCase = ExplorerSubscriptionUseCase(services: service)
        let filtersUseCase = FiltersUseCase()
        let wishListUseCase = WishListUseCase()
        let rewardPointUseCase = RewardPointUseCase()
        let sectionsUseCase = SectionsUseCase()
        let subscriptionBannerUseCase = SubscriptionBannerUseCase(services: service)

        let viewModel = SmilesTouristHomeViewModel(offerUseCase: offersUseCase, subscriptionUseCase: subscriptionUseCase, filtersUseCase: filtersUseCase, sectionsUseCase: sectionsUseCase,rewardPointUseCase: rewardPointUseCase,wishListUseCase: wishListUseCase,subscriptionBannerUseCase:subscriptionBannerUseCase)
        let smilesExplorerHomeViewController = SmilesExplorerHomeViewController.init(viewModel: viewModel, delegate: navigationDelegate)
        viewModel.categoryId = dependance.categoryId
        viewModel.isUserSubscribed = dependance.isUserSubscribed
        viewModel.platinumLimiReached = dependance.platinumLimiReached
        viewModel.subscriptionType = dependance.subscriptionType
        viewModel.isGuestUser = dependance.isGuestUser
        viewModel.rewardPoint = dependance.rewardPoint
        viewModel.rewardPointIcon = dependance.rewardPointIcon
        smilesExplorerHomeViewController.hidesBottomBarWhenPushed = true
        
        return smilesExplorerHomeViewController
    }
    
    //MARK: -  Smiles Tourist Subscribed HomeVC
    public static func getSmilesTouristSubscribedHomeVC(dependance: SmilesTouristDependance,navigationDelegate:SmilesExplorerHomeDelegate) -> SmilesExplorerSubscriptionUpgradeViewController {
        let offersUseCase = OffersListUseCase(services: service)
        let subscriptionUseCase = ExplorerSubscriptionUseCase(services: service)
        let filtersUseCase = FiltersUseCase()
        let wishListUseCase = WishListUseCase()
        let rewardPointUseCase = RewardPointUseCase()
        let sectionsUseCase = SectionsUseCase()
        let subscriptionBannerUseCase = SubscriptionBannerUseCase(services: service)
        
        let viewModel = SmilesTouristHomeViewModel(offerUseCase: offersUseCase, subscriptionUseCase: subscriptionUseCase, filtersUseCase: filtersUseCase, sectionsUseCase: sectionsUseCase,rewardPointUseCase: rewardPointUseCase,wishListUseCase: wishListUseCase,subscriptionBannerUseCase:subscriptionBannerUseCase)
        viewModel.categoryId = dependance.categoryId
        viewModel.isUserSubscribed = dependance.isUserSubscribed
        viewModel.platinumLimiReached = dependance.platinumLimiReached
        viewModel.subscriptionType = dependance.subscriptionType
        viewModel.voucherCode = dependance.voucherCode
        viewModel.isGuestUser = dependance.isGuestUser
        viewModel.rewardPoint = dependance.rewardPoint
        viewModel.rewardPointIcon = dependance.rewardPointIcon
        let smilesExplorerHomeViewController = SmilesExplorerSubscriptionUpgradeViewController.init(viewModel: viewModel, delegate: navigationDelegate)
        smilesExplorerHomeViewController.hidesBottomBarWhenPushed = true
        return smilesExplorerHomeViewController
    }
    
    //MARK: -  Smiles Tourist Offer Listing Controller
    static func getExplorerListingVC(dependence: ExplorerOffersListingDependance, delegate:SmilesExplorerHomeDelegate?) -> ExplorerOffersListingViewController {
        let offersUseCase = OffersListUseCase(services: service)
        let viewModel = ExplorerOffersListingViewModel(offerUseCase: offersUseCase)
        let viewController = ExplorerOffersListingViewController(viewModel: viewModel, dependencies: dependence)
        viewController.delegate = delegate
        return viewController
    }
    
    //MARK: -  Smiles Tourist Service Handler
    static func getFAQsVC() -> FAQsViewController {
        
        let faqsUseCase = FAQsUseCase()
        let viewModel = ExplorerFAQsViewModel(faqsUseCase: faqsUseCase)
        let viewController = FAQsViewController(viewModel: viewModel)
        return viewController
        
    }
    
    static var service: SmilesTouristServiceHandler {
        return .init(repository: repository)
    }
    
    //MARK: -  Smiles Tourist Network Requestable
    static var network: Requestable {
        NetworkingLayerRequestable(requestTimeOut: 60)
    }
    
    //MARK: -  Smiles Tourist Repository
    static var repository: SmilesTouristServiceable {
        SmilesTouristRepository(networkRequest: network)
    }
    
}

