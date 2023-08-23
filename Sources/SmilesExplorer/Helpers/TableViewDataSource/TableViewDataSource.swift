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

extension TableViewDataSource where Model == BOGODetailsResponseLifestyleOffer {
    static func make(forSubscriptions subscriptions: [BOGODetailsResponseLifestyleOffer],
                     reuseIdentifier: String = String(describing: SmilesExplorerMembershipCardsTableViewCell.self), data: String, isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: subscriptions,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (subscription, cell, data, indexPath) in
            guard let cell = cell as? SmilesExplorerMembershipCardsTableViewCell else { return }
            cell.configureCell(with: subscription)
        }
    }
}

extension TableViewDataSource where Model == ExplorerOfferResponse {
    static func make(forOffers collectionsObject: ExplorerOfferResponse,
                     reuseIdentifier: String = "SmilesExplorerHomeTicketsTableViewCell", data: String, isDummy: Bool = false, completion:((ExplorerOffer) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.offers?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data : data,
            isDummy:isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? SmilesExplorerHomeTicketsTableViewCell else {return}
            cell.collectionsData = offer.offers
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { offer in
                completion?(offer)
            }
        }
    }
}
