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
        ) { (header, cell, data, indexPath) in
            guard let cell = cell as? HomeHeaderTableViewCell else {return}
            cell.setupData(header: header)
            cell.setBackGroundColor(color: UIColor(hexString: data))
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

extension TableViewDataSource where Model == [OfferDO] {
    static func make(forOffers collectionsObject: [OfferDO],
                     reuseIdentifier: String = "HomeOffersTableViewCell", data: String, isDummy: Bool = false, title: String? = nil, subtitle: String? = nil, offersIcon: String? = nil, section: SmilesExplorerSectionIdentifier, delegate: HomeOffersDelegate? = nil) -> TableViewDataSource {
        return TableViewDataSource(
            models: [collectionsObject],
            reuseIdentifier: reuseIdentifier,
            data : data,
            isDummy:isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? HomeOffersTableViewCell else {return}
            cell.setupData(offers: offer, title: title, subtitle: subtitle, offersImage: offersIcon, section: section)
            cell.setBackGroundColor(color: UIColor(hexString: data))
            cell.delegate = delegate
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
            cell.favoriteCallback = { isFavorite, offerId in
                completion?(isFavorite, offerId, indexPath)
            }
            
            
        }
    }
}

extension TableViewDataSource where Model == HomeFooter {
    static func make(footer: HomeFooter,
                     reuseIdentifier: String = "SmilesExplorerFooterTableViewCell", title: String?, data: String, isDummy: Bool = false, delegate: ExplorerHomeFooterDelegate? = nil) -> TableViewDataSource {
        return TableViewDataSource(
            models: [footer],
            reuseIdentifier: reuseIdentifier,
            data : data,
            isDummy:isDummy
        ) { (footer, cell, data, indexPath) in
            guard let cell = cell as? SmilesExplorerFooterTableViewCell else {return}
            cell.setupData(title: title, footer: footer)
            if !isDummy {
                cell.delegate = delegate
            }
        }
    }
}

extension TableViewDataSource where Model == OfferDO {
    static func makeForOffersListing(offers: [OfferDO],
                     reuseIdentifier: String = "OffersListingTableViewCell", isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: offers,
            reuseIdentifier: reuseIdentifier,
            data: "FFFFFF",
            isDummy: isDummy
        ) { (offer, cell, data, indexPath) in
            guard let cell = cell as? OffersListingTableViewCell else { return }
            cell.setupData(offer: offer)
        }
    }
}

extension TableViewDataSource where Model == String {
    static func makeForOffersDetail(offers: OfferDetailsResponse,
                     reuseIdentifier: String = "OffersPopupTVC", isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: offers.whatYouGetList ?? [],
            reuseIdentifier: reuseIdentifier,
            data: "FFFFFF",
            isDummy: isDummy
        ) { (offerDesc, cell, data, indexPath) in
            guard let cell = cell as? OffersPopupTVC else { return }
            cell.configure(title: offerDesc)
        }
    }
}

extension TableViewDataSource where Model == OfferDetailsResponse {
    static func makeForOffersDetailHeader(offers: OfferDetailsResponse,
                     reuseIdentifier: String = "OfferDetailPopupHeaderTVC", isDummy: Bool = false) -> TableViewDataSource {
        return TableViewDataSource(
            models: [offers],
            reuseIdentifier: reuseIdentifier,
            data: "FFFFFF",
            isDummy: isDummy
        ) { (headerResp, cell, data, indexPath) in
            guard let cell = cell as? OfferDetailPopupHeaderTVC else { return }
            cell.setupData(offer: headerResp)
            
        }
    }
}
