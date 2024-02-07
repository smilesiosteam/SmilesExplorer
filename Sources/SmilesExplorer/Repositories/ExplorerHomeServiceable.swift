//
//  File.swift
//
//
//  Created by Abdul Rehman Amjad on 07/02/2024.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesBaseMainRequestManager

protocol ExplorerHomeServiceable {
    func getSubscriptionBannerDetails(request: SmilesBaseMainRequest) -> AnyPublisher<ExplorerSubscriptionBannerResponse, NetworkError>
}

class ExplorerHomeRepository: ExplorerHomeServiceable {
    
    private var networkRequest: Requestable
    private var baseUrl: String
    private var endPoint: ExplorerHomeEndPoints
    
    // inject this for testability
    init(networkRequest: Requestable, baseUrl: String, endPoint: ExplorerHomeEndPoints) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        self.endPoint = endPoint
    }
    
    func getSubscriptionBannerDetails(request: SmilesBaseMainRequest) -> AnyPublisher<ExplorerSubscriptionBannerResponse, NetworkError> {
        let endPoint = ExplorerHomeRequestBuilder.getSubscriptionBannerDetails(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl, endPoint: .getSubscriptionBannerDetails)
        
        return self.networkRequest.request(request)
    }
    
}
