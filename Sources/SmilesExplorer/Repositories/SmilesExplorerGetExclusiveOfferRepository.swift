//
//  File.swift
//  
//
//  Created by Habib Rehman on 22/08/2023.
//


import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesOffers

protocol SmilesExplorerGetExclusiveOfferServiceable {
    func getExclusiveOffers(request: ExplorerGetExclusiveOfferRequest) -> AnyPublisher<ExplorerOfferResponse, NetworkError>
    func getBogoOffers(request: ExplorerGetExclusiveOfferRequest) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
    
}

// GetCuisinesRepository
class SmilesExplorerGetExclusiveOfferRepository: SmilesExplorerGetExclusiveOfferServiceable {
    
    
    
    
    
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endpoint: SmilesExplorerEndpoints
    

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endpoint: SmilesExplorerEndpoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endpoint = endpoint
        
    }
    
    func getExclusiveOffers(request: ExplorerGetExclusiveOfferRequest) -> AnyPublisher<ExplorerOfferResponse, NetworkError> {
        
        let endPoint = SmilesExplorerSubscriptionInfoRequestBuilder.getExclusiceOffer(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endpoint: self.endpoint)
        return self.networkRequest.request(request)
        
    }
    
    func getBogoOffers(request: ExplorerGetExclusiveOfferRequest) -> AnyPublisher<OffersCategoryResponseModel, NetworkError> {
        let endPoint = SmilesExplorerSubscriptionInfoRequestBuilder.getExclusiceOffer(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endpoint: self.endpoint)
        return self.networkRequest.request(request)
    }
}

