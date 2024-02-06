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
import SmilesStoriesManager

extension TableViewDataSource where Model == HomeHeaderResponse {
    static func make(header: HomeHeaderResponse,
                     reuseIdentifier: String = "HomeHeaderTableViewCell", data: String, isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: [header],
            reuseIdentifier: reuseIdentifier,
            data : data,
            isDummy:isDummy
        ) { (offer, cell, data, indexPath) in
//            guard let cell = cell as? HomeHeaderTableViewCell else {return}
//            cell.setBackGroundColor(color: UIColor(hexString: data))
        }
    }
}


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
            cell.selectionStyle = .none
        }
    }
}

extension TableViewDataSource where Model == OffersCategoryResponseModel {
    static func make(forOffers collectionsObject: OffersCategoryResponseModel,
                     reuseIdentifier: String = "HomeOffersTableViewCell", data: String, isDummy: Bool = false, title: String? = nil, subtitle: String? = nil, offersImage: String? = nil, isForTickets: Bool = false, completion:((OfferDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.offers?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data : data,
            isDummy:isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? HomeOffersTableViewCell else {return}
            cell.setupData(offers: offer.offers, title: title, subtitle: subtitle, offersImage: offersImage, isForTickets: isForTickets)
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = completion
        }
    }
}

extension TableViewDataSource where Model == OffersCategoryResponseModel {
    static func make(forBogoHomeOffers collectionsObject: OffersCategoryResponseModel,
                     reuseIdentifier: String = "SmilesExplorerHomeDealsAndOffersTVC", data: String, isDummy: Bool = false, completion:((OfferDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.offers?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data : data,
            isDummy:isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? SmilesExplorerHomeDealsAndOffersTVC else {return}
            cell.collectionsData = offer.offers
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.callBack = { offer in
                completion?(offer)
            }
        }
    }
}

extension TableViewDataSource where Model == OffersCategoryResponseModel {
    static func make(forStories collectionsObject: OffersCategoryResponseModel,
                     reuseIdentifier: String = "SmilesExplorerStoriesTVC", data : String, isDummy:Bool = false, onClick:((OfferDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.offers?.count ?? 0 > 0}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (storiesOffer, cell, data, indexPath) in
            guard let cell = cell as? SmilesExplorerStoriesTVC else {return}
            cell.collectionsData = storiesOffer.offers
            cell.setBackGroundColor(color: UIColor(hexString: data))

            cell.callBack = { data in
                debugPrint(data)
                onClick?(data)
            }
        }
    }
}

extension TableViewDataSource where Model == SectionDetailDO {
    static func make(forUpgradeBanner collectionsObject: SectionDetailDO,
                     reuseIdentifier: String = "UpgradeBannerTVC", data : String, isDummy:Bool = false, onClick:((SectionDetailDO) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject].filter({$0.backgroundImage != nil}),
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (sectionDetail, cell, data, indexPath) in
            guard let cell = cell as? UpgradeBannerTVC else {return}
            cell.sectionData = sectionDetail
            
            
        }
    }
}



extension TableViewDataSource where Model == OfferDO {
    static func make(forBogoOffers offers: [OfferDO], offerCellType: RestaurantsRevampTableViewCell.OfferCellType = .smilesExplorer,
                     reuseIdentifier: String = "RestaurantsRevampTableViewCell", data: String, isDummy: Bool = false, completion: ((Bool, String, IndexPath?) -> ())?) -> TableViewDataSource {
        return TableViewDataSource(
            models: offers,
            reuseIdentifier: reuseIdentifier,
            data: data,
            isDummy: isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? RestaurantsRevampTableViewCell else { return }
            cell.configureCell(with: offer)
            cell.offerCellType = offerCellType
            cell.selectionStyle = .none
            //            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.favoriteCallback = { isFavorite, offerId in
                completion?(isFavorite, offerId, indexPath)
            }
            
            
        }
    }
}
