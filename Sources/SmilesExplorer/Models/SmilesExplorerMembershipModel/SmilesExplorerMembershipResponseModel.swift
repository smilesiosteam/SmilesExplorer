//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 17/08/2023.
//

import Foundation

public struct ThemeResources: Codable {
    let explorerSubscriptionTitle: String
    let explorerSubscriptionSubTitle: String
    let explorerPurchaseSuccessImage: String
    let explorerPurchaseSuccessTitle: String
    let passPurchaseSuccessMsg: String
    let ticketPurchaseSuccessMsg: String
}

public struct WhatYouGetItem: Codable {
    let text: String
    let iconUrl: String?
}

public struct PaymentMethod: Codable {
    let paymentMethodId: String
    let description: String
    let title: String
    let titleAr: String
    let iconUrl: String
    let paymentType: String
    let paymentTypeText: String
}

public struct LifestyleOffer: Codable {
    let isSubscription: Bool
    let subscribedOfferTitle: String
    let subscribeImage: String
    let offerId: String
    let offerTitle: String
    let offerDescription: String
    let duration: Int
    let fullDuration: String
    let freeDuration: Int
    let price: Int
    let pointsValue: Double
    let monthlyPriceCost: String
    let monthlyPrice: String
    let whatYouGetTitle: String
    let whatYouGetText: String
    let whatYouGetTextList: [String]
    let whatYouGet: [WhatYouGetItem]
    let termsAndConditions: String
    let paymentMethods: [PaymentMethod]
    let subscriptionSegment: String
    let redirectionUrl: String
    let autoRenewable: Bool
    let expiryDate: String
}

public struct SmilesExplorerMembershipResponseModel: Codable {
    let extTransactionId: String
    let themeResources: ThemeResources
    let isCustomerElgibile: Bool
    let lifestyleOffers: [LifestyleOffer]
}
