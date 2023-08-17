//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/08/2023.
//

import Foundation
import SmilesUtilities
import SmilesSharedServices
import UIKit
import SmilesOffers
import SmilesBanners

extension TableViewDataSource where Model == OfferDO {
    static func make(forNearbyOffers nearbyOffersObjects: [OfferDO], offerCellType: RestaurantsRevampTableViewCell.OfferCellType = .manCity,
                     reuseIdentifier: String = "RestaurantsRevampTableViewCell", data: String, isDummy: Bool = false, completion: ((Bool, String, IndexPath?) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: nearbyOffersObjects,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? RestaurantsRevampTableViewCell else { return }
            cell.configureCell(with: offer)
            cell.offerCellType = offerCellType
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.favoriteCallback = { isFavorite, offerId in
                completion?(isFavorite, offerId, indexPath)
            }
        }
    }
}

extension TableViewDataSource where Model == GetTopOffersResponseModel {
    static func make(forTopOffers collectionsObject: GetTopOffersResponseModel,
                     reuseIdentifier: String = "TopOffersTableViewCell", data : String, isDummy:Bool = false, completion:((GetTopOffersResponseModel.TopOfferAdsDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.ads?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (topOffers, cell, data, indexPath) in
            guard let cell = cell as? TopOffersTableViewCell else {return}
            // need to uncomment below line after testing functionality
           // cell.showPageControl = false
            cell.sliderTimeInterval = topOffers.sliderTimeout
            cell.collectionsData = topOffers.ads
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { data in
                completion?(data)
            }
        }
    }
}
