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
    
    override init() {
        super.init()
    }
    
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
public class ExplorerOffer: Codable {
    public var offerID, offerTitle, offerDescription, pointsValue: String?
    public var dirhamValue, offerType, categoryID: String?
    public var imageURL: String?
    public var partnerName: String?
    public var isWishlisted: Bool?
    public var partnerImage: String?
    public var smileyPointsURL: String?
    public var redirectionUrL: String?
    public var paymentMethods: [PaymentMethod]?
    
    public enum CodingKeys: String, CodingKey {
        case offerID = "offerId"
        case offerTitle, offerDescription, pointsValue, dirhamValue, offerType
        case categoryID = "categoryId"
        case imageURL, partnerName, isWishlisted, partnerImage
        case smileyPointsURL = "smileyPointsUrl"
        case redirectionUrL = "redirectionUrL"
        case paymentMethods
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.offerID = try container.decodeIfPresent(String.self, forKey: .offerID)
        self.offerTitle = try container.decodeIfPresent(String.self, forKey: .offerTitle)
        self.offerDescription = try container.decodeIfPresent(String.self, forKey: .offerDescription)
        self.pointsValue = try container.decodeIfPresent(String.self, forKey: .pointsValue)
        self.dirhamValue = try container.decodeIfPresent(String.self, forKey: .dirhamValue)
        self.offerType = try container.decodeIfPresent(String.self, forKey: .offerType)
        self.categoryID = try container.decodeIfPresent(String.self, forKey: .categoryID)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.partnerName = try container.decodeIfPresent(String.self, forKey: .partnerName)
        self.isWishlisted = try container.decodeIfPresent(Bool.self, forKey: .isWishlisted)
        self.partnerImage = try container.decodeIfPresent(String.self, forKey: .partnerImage)
        self.smileyPointsURL = try container.decodeIfPresent(String.self, forKey: .smileyPointsURL)
        self.redirectionUrL = try container.decodeIfPresent(String.self, forKey: .redirectionUrL)
        self.paymentMethods = try container.decodeIfPresent([PaymentMethod].self, forKey: .paymentMethods)
    }
    

    
}
