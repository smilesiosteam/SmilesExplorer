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
   
    public static func getSmilesTouristHomeVC(dependance: SmilesTouristDependance,navigationDelegate:SmilesExplorerHomeDelegate) -> SmilesExplorerSubscriptionUpgradeViewController {
        let offersUseCase = OffersListUseCase(services: service)
        let subscriptionUseCase = SmilesExplorerSubscriptionUseCase(services: service)
        let filtersUseCaseProtocol = FiltersUseCase()
        let viewModel = SmilesTouristHomeViewModel(offerUseCase: offersUseCase, subscriptionUseCase: subscriptionUseCase, filtersUseCaseProtocol:filtersUseCaseProtocol)
        let viewController = SmilesExplorerSubscriptionUpgradeViewController(categoryId: dependance.categoryId, isGuestUser: dependance.isGuestUser, delegate: navigationDelegate, rewardPoint: dependance.rewardPoint ?? 0, rewardPointIcon: dependance.rewardPointIcon ?? "", personalizationEventSource: dependance.personalizationEventSource, platinumLimiReached: dependance.platinumLimiReached)
        viewController.viewModl = viewModel
        viewController.delegate = navigationDelegate
        return viewController
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

