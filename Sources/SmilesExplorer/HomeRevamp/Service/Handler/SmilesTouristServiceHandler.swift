//
//  SmilesTouristServiceHandler.swift
//
//
//  Created by Habib Rehman on 22/01/2024.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesBaseMainRequestManager
import SmilesOffers

protocol SmilesTouristServiceHandlerProtocol {
    
    func getOffers(categoryId: Int?, tag: SectionTypeTag?, pageNo: Int?,categoryTypeIdsList: [String]?) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
    func getSubscriptionInfo(_ packageType: String?) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkError>
    func getSubscriptionBannerDetails() -> AnyPublisher<ExplorerSubscriptionBannerResponse, NetworkError>
    
}

final class SmilesTouristServiceHandler: SmilesTouristServiceHandlerProtocol {
    
    // MARK: - Properties
    private let repository: SmilesTouristServiceable
    
    // MARK: - Init
    init(repository: SmilesTouristServiceable) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getOffers(categoryId: Int?, tag: SectionTypeTag?, pageNo: Int?,categoryTypeIdsList: [String]? = nil) -> AnyPublisher<OffersCategoryResponseModel, NetworkingLayer.NetworkError> {
        let request = ExplorerGetExclusiveOfferRequest(categoryId: categoryId,tag: tag?.rawValue, pageNo: pageNo)
        return repository.getOffers(request: request)
    }
    
    func getSubscriptionInfo(_ packageType: String?) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkError> {
        let request = SmilesExplorerSubscriptionInfoRequest()
        return repository.getSubscriptionInfoService(request: request)
    }
    
    func getSubscriptionBannerDetails() -> AnyPublisher<ExplorerSubscriptionBannerResponse,NetworkError> {
        let request = ExplorerSubscriptionBannerRequest()
        return repository.getSubscriptionBannerDetails(request: request)
    }
    
}


