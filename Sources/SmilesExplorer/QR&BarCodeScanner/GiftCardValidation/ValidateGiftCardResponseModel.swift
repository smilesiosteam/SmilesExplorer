//
//  ValidateGiftCardResponseModel.swift
//  
//
//  Created by Shmeel Ahmed on 11/09/2023.
//


import Foundation
import NetworkingLayer
import SmilesUtilities

class ValidateGiftCardResponseModel: BaseMainResponse {
    let themeResources: ThemeResources?
    let lifestyleOffers : [BOGODetailsResponseLifestyleOffer]?
    let promoCode: BOGOPromoCode?
    let isValid: Bool?
    
    
    
    enum BOGODetailsCodingKeys: String, CodingKey {
        case themeResources
        case lifestyleOffers
        case isValid
        case promoCode
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: BOGODetailsCodingKeys.self)
        themeResources = try values.decodeIfPresent(ThemeResources.self, forKey: .themeResources)
        lifestyleOffers = try values.decodeIfPresent([BOGODetailsResponseLifestyleOffer].self, forKey: .lifestyleOffers)
        isValid = try values.decodeIfPresent(Bool.self, forKey: .isValid)
        promoCode = try values.decodeIfPresent(BOGOPromoCode.self, forKey: .promoCode)
        try super.init(from: decoder)
    }
    
}
