//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 18/08/2023.
//

import Foundation
import SmilesUtilities
import NetworkingLayer

// MARK: - Welcome
class ExplorerOfferResponse: BaseMainResponse {
    
    var listTitle, listSubtitle: String?
    var offers: [ExplorerOffer]?
    var offersCount: Int?

    enum CodingKeys: String, CodingKey {
        case listTitle, listSubtitle, offers, offersCount
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        listTitle = try values.decodeIfPresent(String.self, forKey: .listTitle)
        listSubtitle = try values.decodeIfPresent(String.self, forKey: .listSubtitle)
        offers = try values.decodeIfPresent([ExplorerOffer].self, forKey: .offers)
        offersCount = try values.decodeIfPresent(Int.self, forKey: .offersCount)
        try super.init(from: decoder)
    }

}

// MARK: - Offer
class ExplorerOffer: Codable {
    var offerID, offerTitle, offerDescription, pointsValue: String?
    var dirhamValue, offerType, categoryID: String?
    var imageURL: String?
    var partnerName: String?
    var isWishlisted: Bool?
    var partnerImage: String?
    var smileyPointsURL: String?
    var redirectionURL: String?
    var paymentMethods: [PaymentMethod]?

    enum CodingKeys: String, CodingKey {
        case offerID = "offerId"
        case offerTitle, offerDescription, pointsValue, dirhamValue, offerType
        case categoryID = "categoryId"
        case imageURL, partnerName, isWishlisted, partnerImage
        case smileyPointsURL = "smileyPointsUrl"
        case redirectionURL, paymentMethods
    }

}