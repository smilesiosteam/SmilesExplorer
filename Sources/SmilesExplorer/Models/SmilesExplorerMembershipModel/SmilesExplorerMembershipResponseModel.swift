//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 17/08/2023.
//

import Foundation

struct ThemeResources: Codable {
    let explorerSubscriptionTitle: String
    let explorerSubscriptionSubTitle: String
    let explorerPurchaseSuccessImage: String
    let explorerPurchaseSuccessTitle: String
    let passPurchaseSuccessMsg: String
    let ticketPurchaseSuccessMsg: String
}

struct LifestyleOffer: Codable {
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
}

struct WhatYouGetItem: Codable {
    let text: String
    let iconUrl: String?
}

struct PaymentMethod: Codable {
    let paymentMethodId: String
    let description: String
    let title: String
    let titleAr: String
    let iconUrl: String
    let paymentType: String
    let paymentTypeText: String
}

struct SmilesExplorerMembershipResponseModel: Codable {
    let extTransactionId: String
    let themeResources: ThemeResources
    let isCustomerEligible: Bool
    let lifestyleOffers: [LifestyleOffer]
}

