//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesOffers
import SmilesBaseMainRequestManager

protocol SmilesExplorerOffersServiceable {
    func smilesExplorerOffersService(request: SmilesBaseMainRequest) -> AnyPublisher<OffersCategoryResponseModel, NetworkError>
}

class SmilesExplorerOffersRepository: SmilesExplorerOffersServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: SmilesExplorerOffersEndPoints

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: SmilesExplorerOffersEndPoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
  
    func smilesExplorerOffersService(request: SmilesBaseMainRequest) -> AnyPublisher<OffersCategoryResponseModel, NetworkError> {
        let endPoint = SmilesExplorerOffersRequestBuilder.getSmilesExplorerOffers(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .fetchOffersList)
        
        return self.networkRequest.request(request)
    }
}
