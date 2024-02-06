//
//  SmilesTouristRepository.swift
//  
//
//  Created by Habib Rehman on 22/01/2024.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesOffers
import SmilesBaseMainRequestManager

protocol SmilesTouristServiceable {
    
    func getOffers(request: ExplorerGetExclusiveOfferRequest) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
    
    func smilesExplorerValidateGiftService(request: ValidateGiftCardRequestModel) -> AnyPublisher<ValidateGiftCardResponseModel, NetworkError>
    
    func getSubscriptionInfoService(request: SmilesExplorerSubscriptionInfoRequest) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkError>
}

final class SmilesTouristRepository: SmilesTouristServiceable {
    
    // MARK: - Properties
    private let networkRequest: Requestable
    
    // MARK: - Init
    init(networkRequest: Requestable) {
        self.networkRequest = networkRequest
    }
  
    // MARK: - Services
    
    func getOffers(request: ExplorerGetExclusiveOfferRequest) -> AnyPublisher<OffersCategoryResponseModel, NetworkError> {
        let endPoint = SmilesTouristRequestBuilder.getOffers(request: request)
        let request = endPoint.createRequest(endPoint: .fetchOffersList)
        return self.networkRequest.request(request)
    }
    
    // MARK: - ValidateGift Service
    func smilesExplorerValidateGiftService(request: ValidateGiftCardRequestModel) -> AnyPublisher<ValidateGiftCardResponseModel, NetworkingLayer.NetworkError> {
        let endPoint = SmilesTouristRequestBuilder.validateSmilesExplorerGift(request: request)
        let request = endPoint.createRequest(endPoint: .validateGift)
        return self.networkRequest.request(request)
    }
    // MARK: - Subscription Info Service
    func getSubscriptionInfoService(request: SmilesExplorerSubscriptionInfoRequest) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkingLayer.NetworkError> {
        let endPoint = SmilesTouristRequestBuilder.getSubscriptionInfo(request: request)
        let request = endPoint.createRequest(endPoint: .subscriptionInfo)
        return self.networkRequest.request(request)
    }
}

