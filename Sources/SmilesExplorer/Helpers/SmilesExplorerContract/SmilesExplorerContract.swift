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
        case getSections(categoryID: Int)
        case getFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?)
        case removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel)
        case getSortingList
        case generateActionContentForSortingItems(sortingModel: GetSortingListResponseModel?)
        case setFiltersSavedList(filtersSavedList: [RestaurantRequestWithNameFilter]?, filtersList: [RestaurantRequestFilter]?)
        case setSelectedSort(sortTitle: String?)
    }
    
    enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchFiltersDataSuccess(filters: [FiltersCollectionViewCellRevampModel], selectedSortingTableViewCellModel: FilterDO?)
        case fetchAllSavedFiltersSuccess(filtersList: [RestaurantRequestFilter], filtersSavedList: [RestaurantRequestWithNameFilter])
        
        case fetchSavedFiltersAfterSuccess(filtersSavedList: [RestaurantRequestWithNameFilter])
        case fetchContentForSortingItems(baseRowModels: [BaseRowModel])
        
        case fetchSortingListDidSucceed
        
        case fetchTopOffersDidSucceed(response: GetTopOffersResponseModel)
    }
    
}
