//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesBaseMainRequestManager

enum SmilesExplorerOffersRequestBuilder {
    
    
    case getSmilesExplorerOffers(request: SmilesBaseMainRequest)
    case validateSmilesExplorerGift(request: ValidateGiftCardRequestModel)
    
    
    var requestTimeOut: Int {
        return 20
    }
    
    
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getSmilesExplorerOffers,.validateSmilesExplorerGift:
            return .POST
        }
    }
    
    // compose the NetworkRequest
    func createRequest(baseUrl: String, endPoint: SmilesExplorerOffersEndPoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(baseUrl: baseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    
    var requestBody: Encodable? {
        switch self {
        case .getSmilesExplorerOffers(let request):
            return request
        case .validateSmilesExplorerGift(request: let request):
            return request
        }
    }
    
    
    func getURL(baseUrl: String, for endPoint: SmilesExplorerOffersEndPoints) -> String {
        return baseUrl + endPoint.serviceEndPoints
    }
}

