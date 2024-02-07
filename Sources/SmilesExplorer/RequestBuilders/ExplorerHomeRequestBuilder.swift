//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 07/02/2024.
//

import Foundation
import NetworkingLayer
import SmilesBaseMainRequestManager

enum ExplorerHomeRequestBuilder {
    
    case getSubscriptionBannerDetails(request: SmilesBaseMainRequest)
    
    var requestTimeOut: Int {
        return 20
    }
    
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getSubscriptionBannerDetails:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseUrl: String, endPoint: ExplorerHomeEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    
    private var requestBody: Encodable? {
        switch self {
        case .getSubscriptionBannerDetails(let request):
            return request
        }
    }
    
    
    private func getURL(baseUrl: String, for endPoint: ExplorerHomeEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
    
}

