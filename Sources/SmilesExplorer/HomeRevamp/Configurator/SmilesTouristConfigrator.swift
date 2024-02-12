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

public struct SmilesTouristDependance {
    public var categoryId: Int?
    public var selectedSort: String?
    public var rewardPoint: Int?
    public var rewardPointIcon: String?
    public var personalizationEventSource: String?
    public var platinumLimiReached: Bool?
    public let isGuestUser: Bool
    public var isUserSubscribed: Bool?
    public var subscriptionType: ExplorerPackage?
    public var voucherCode: String?
    public var delegate:SmilesExplorerHomeDelegate? = nil
    

    public init(categoryId: Int?, isGuestUser: Bool, isUserSubscribed: Bool? = nil, subscriptionType: ExplorerPackage? = nil, voucherCode: String? = nil, delegate:SmilesExplorerHomeDelegate, rewardPoint: Int, rewardPointIcon: String,personalizationEventSource: String?,platinumLimiReached: Bool?) {
        self.platinumLimiReached = platinumLimiReached
        self.personalizationEventSource =  personalizationEventSource
        self.categoryId = categoryId
        self.isGuestUser = isGuestUser
        self.isUserSubscribed = isUserSubscribed
        self.subscriptionType = subscriptionType
        self.voucherCode = voucherCode
        self.delegate = delegate
        self.rewardPointIcon = rewardPointIcon
        self.rewardPoint = rewardPoint
        
    }
}


public enum SmilesTouristConfigrator {
   
    public static func getSmilesTouristHomeVC(dependance: SmilesTouristDependance,navigationDelegate:SmilesExplorerHomeDelegate) -> SmilesExplorerHomeViewController {
        
        let offersUseCase = OffersListUseCase(services: service)
        let subscriptionUseCase = ExplorerSubscriptionUseCase(services: service)
        let filtersUseCase = FiltersUseCase()
        let wishListUseCase = WishListUseCase()
        let rewardPointUseCase = RewardPointUseCase()
        let sectionsUseCase = SectionsUseCase()
        let subscriptionBannerUseCase = SubscriptionBannerUseCase(services: service)
        
        let viewModel = SmilesTouristHomeViewModel(offerUseCase: offersUseCase, subscriptionUseCase: subscriptionUseCase, filtersUseCase: filtersUseCase, sectionsUseCase: sectionsUseCase,rewardPointUseCase: rewardPointUseCase,wishListUseCase: wishListUseCase,subscriptionBannerUseCase:subscriptionBannerUseCase)
        
        let smilesExplorerHomeViewController = SmilesExplorerHomeViewController.init()
        smilesExplorerHomeViewController.hidesBottomBarWhenPushed = true
        
        smilesExplorerHomeViewController.viewModel = viewModel
        smilesExplorerHomeViewController.delegate = navigationDelegate
        
        return smilesExplorerHomeViewController
    }
    
    static func getExplorerListingVC(dependence: ExplorerOffersListingDependance) -> ExplorerOffersListingViewController {
        
        let offersUseCase = OffersListUseCase(services: service)
        let viewModel = ExplorerOffersListingViewModel(offerUseCase: offersUseCase)
        let viewController = ExplorerOffersListingViewController(viewModel: viewModel, dependencies: dependence)
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

