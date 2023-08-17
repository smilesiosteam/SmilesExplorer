//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/08/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

protocol SmilesExplorerSubscriptionInfoServiceable {
    func getSubscriptionInfoService(request: SmilesExplorerSubscriptionInfoRequest) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkError>
    
}

// GetCuisinesRepository
class SmilesExplorerSubscriptionInfoRepository: SmilesExplorerSubscriptionInfoServiceable {
    private var networkRequest: Requestable
    private var baseUrl: String
    

  // inject this for testability
    init(networkRequest: Requestable, baseUrl: String) {
        self.networkRequest = networkRequest
        self.baseUrl = baseUrl
        
    }
    
    func getSubscriptionInfoService(request: SmilesExplorerSubscriptionInfoRequest) -> AnyPublisher<SmilesExplorerSubscriptionInfoResponse, NetworkError> {
        
        let endPoint = SmilesExplorerSubscriptionInfoRequestBuilder.getSubscriptionInfo(request: request)
        let request = endPoint.createRequest(baseUrl: baseUrl)
        return self.networkRequest.request(request)
        
    }
    
}
