//
//  SmilesTouristRequestBuilder.swift
//  
//
//  Created by Habib Rehman on 22/01/2024.
//

import Foundation
import NetworkingLayer
import SmilesUtilities
import SmilesBaseMainRequestManager


enum SmilesTouristRequestBuilder {
    // MARK: -  organise all the end points here for clarity
    case getOffers(request: ExplorerGetExclusiveOfferRequest)
    case getSubscriptionInfo(request: SmilesExplorerSubscriptionInfoRequest)
    case validateSmilesExplorerGift(request: ValidateGiftCardRequestModel)
    case getSubscriptionBannerDetails(request: ExplorerSubscriptionBannerRequest)
   
    // MARK: -  gave a default timeout but can be different for each.
    var requestTimeOut: Int {
        return 20
    }
    
    // MARK: - specify the type of HTTP request
    var httpMethod: SmilesHTTPMethod {
        switch self {
        case .getOffers:
            return .POST
        case .getSubscriptionInfo:
            return .POST
        case .validateSmilesExplorerGift:
            return .POST
        case .getSubscriptionBannerDetails:
            return .POST
        }
    }
    
    // MARK: - compose the NetworkRequest
    func createRequest(endPoint: SmilesTouristEndpoints) -> NetworkRequest {
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
        headers["CUSTOM_HEADER"] = "pre_prod"
        
        return NetworkRequest(url: getURL(from: AppCommonMethods.serviceBaseUrl, for: endPoint), headers: headers, reqBody: requestBody, httpMethod: httpMethod)
    }
    
    // MARK: - encodable request body for POST
    var requestBody: Encodable? {
        switch self {
        case .getOffers(let request):
            return request
        case .getSubscriptionInfo(request: let request):
            return request
        case .validateSmilesExplorerGift(request: let request):
            return request
        case .getSubscriptionBannerDetails(request: let request):
            return request
        }
    }
    
    // MARK: -  compose urls for each request
    func getURL(from baseUrl: String, for endPoint: SmilesTouristEndpoints) -> String {
        let endPoint = endPoint.url
        switch self {
        case .getOffers:
            return "\(baseUrl)\(endPoint)"
        case .getSubscriptionInfo:
            return "\(baseUrl)\(endPoint)"
        case .validateSmilesExplorerGift:
            return "\(baseUrl)\(endPoint)"
        case .getSubscriptionBannerDetails:
            return "\(baseUrl)\(endPoint)"
        }
    }
}

