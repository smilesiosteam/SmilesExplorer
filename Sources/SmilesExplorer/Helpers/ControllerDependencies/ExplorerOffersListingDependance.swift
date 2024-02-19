//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 12/02/2024.
//

import Foundation
import SmilesOffers

public struct ExplorerOffersListingDependance {
    let categoryId: Int
    let title: String
    var offersResponse: OffersCategoryResponseModel
    let offersTag: SectionTypeTag
}
