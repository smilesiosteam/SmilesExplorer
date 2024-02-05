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
    
    func getExclusiveOffers(categoryId: Int?, tag: String?, pageNo: Int?) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
    func getBogoOffers(categoryId: Int?, tag: String?, pageNo: Int?) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
    func getSubscriptionInfo(_ packageType: String?) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkError>
}

final class SmilesTouristServiceHandler: SmilesTouristServiceHandlerProtocol {
    
    // MARK: - Properties
    private let repository: SmilesTouristServiceable
    
    // MARK: - Init
    init(repository: SmilesTouristServiceable) {
        self.repository = repository
    }
    
    // MARK: - Functions
    func getExclusiveOffers(categoryId: Int?, tag: String?, pageNo: Int?) -> AnyPublisher<OffersCategoryResponseModel, NetworkingLayer.NetworkError> {
        let request = ExplorerGetExclusiveOfferRequest(categoryId: categoryId, pageNo: pageNo)
        return repository.getExclusiveOffers(request: request)
    }
    
    func getBogoOffers(categoryId: Int?, tag: String?, pageNo: Int?) -> AnyPublisher<OffersCategoryResponseModel, NetworkingLayer.NetworkError> {
        let request = ExplorerGetExclusiveOfferRequest(categoryId: categoryId, pageNo: pageNo)
        return repository.getExclusiveOffers(request: request)
    }
    
    func getSubscriptionInfo(_ packageType: String?) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkError> {
        let request = SmilesExplorerSubscriptionInfoRequest()
        return repository.getSubscriptionInfoService(request: request)
    }
    
}


