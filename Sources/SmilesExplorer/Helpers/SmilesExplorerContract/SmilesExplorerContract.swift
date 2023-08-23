//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/08/2023.
//

import Foundation
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesBanners

extension SmilesExplorerHomeViewModel {
    
    enum Input {
        case getSections(categoryID: Int, type: String)
        case getRewardPoints
        case getFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?)
        case removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel)
        case getSortingList
        case generateActionContentForSortingItems(sortingModel: GetSortingListResponseModel?)
        case setFiltersSavedList(filtersSavedList: [RestaurantRequestWithNameFilter]?, filtersList: [RestaurantRequestFilter]?)
        case setSelectedSort(sortTitle: String?)
///        The value of Tag is the Section Identifier.
        case exclusiveDeals(categoryId: Int?, tag: String?,pageNo:Int?)
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchFiltersDataSuccess(filters: [FiltersCollectionViewCellRevampModel], selectedSortingTableViewCellModel: FilterDO?)
        case fetchAllSavedFiltersSuccess(filtersList: [RestaurantRequestFilter], filtersSavedList: [RestaurantRequestWithNameFilter])
        
        case fetchRewardPointsDidSucceed(response: RewardPointsResponseModel, shouldLogout: Bool?)
        case fetchRewardPointsDidFail(error: Error)
        
        case fetchSavedFiltersAfterSuccess(filtersSavedList: [RestaurantRequestWithNameFilter])
        case fetchContentForSortingItems(baseRowModels: [BaseRowModel])
        
        case fetchSortingListDidSucceed
        case fetchSortingListDidFail(error: Error)
        
        case fetchTopOffersDidSucceed(response: GetTopOffersResponseModel)
        case fetchTopOffersDidFail(error: Error)
        
        case fetchExclusiveOffersDidSucceed(response: ExplorerOfferResponse)
        case fetchExclusiveOffersDidFail(error: Error)
    }
    
}
