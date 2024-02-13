//
//  File.swift
//
//
//  Created by Habib Rehman on 06/02/2024.
//

import Foundation
import Combine
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers
import UIKit
import NetworkingLayer


protocol FiltersUseCaseProtocol {
    func createFilters(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?,completion: @escaping ([FiltersCollectionViewCellRevampModel]) -> Void)
    func removeAndSaveFilters(filtersList: [RestaurantRequestFilter]?, filtersSavedList: [RestaurantRequestWithNameFilter]?,filter: FiltersCollectionViewCellRevampModel, completion: @escaping ([RestaurantRequestFilter], [RestaurantRequestWithNameFilter]) -> Void)
}


final class FiltersUseCase: FiltersUseCaseProtocol {
        

    
    // MARK: - Create Filters Data For SmileTourist
    func createFilters(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?, completion: @escaping ([FiltersCollectionViewCellRevampModel]) -> Void) {
        var filters = [FiltersCollectionViewCellRevampModel]()
        
        // Filter List
        var firstFilter = FiltersCollectionViewCellRevampModel(name: "Filters".localizedString, leftImage: "", rightImage: "filter-icon-new", filterCount: filtersSavedList?.count ?? 0)
        
        let firstFilterRowWidth = AppCommonMethods.getAutoWidthWith(firstFilter.name, fontTextStyle: .smilesTitle1, additionalWidth: 60)
        firstFilter.rowWidth = firstFilterRowWidth
        
        if isFilterAllowed != 0 {
            filters.append(firstFilter)
        }
        
        if let appliedFilters = filtersSavedList, appliedFilters.count > 0 {
            for filter in appliedFilters {
                let width = AppCommonMethods.getAutoWidthWith(filter.filterName.asStringOrEmpty(),
                                                              fontTextStyle: .smilesTitle1,
                                                              additionalWidth: 40)
                let model = FiltersCollectionViewCellRevampModel(name: filter.filterName.asStringOrEmpty(), 
                                                                 leftImage: "",
                                                                 rightImage: "filters-cross",
                                                                 isFilterSelected: true, filterValue: filter.filterValue.asStringOrEmpty(),
                                                                 tag: 0, rowWidth: width)
                filters.append(model)
            }
        }
        completion(filters)
    }
    
    
    // MARK: - Remove Filters
    func removeAndSaveFilters(filtersList: [RestaurantRequestFilter]?, filtersSavedList: [RestaurantRequestWithNameFilter]?,filter: FiltersCollectionViewCellRevampModel, completion: @escaping ([RestaurantRequestFilter], [RestaurantRequestWithNameFilter]) -> Void) {
        
        var filtersLists:[RestaurantRequestFilter] = filtersList ?? []
        var filtersSavedLists:[RestaurantRequestWithNameFilter] = filtersSavedList ?? []
        
        let isFilteredIndex = filtersSavedList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.name.lowercased() == restaurantRequestWithNameFilter.filterName?.lowercased()
        })
        
        if let isFilteredIndex = isFilteredIndex {
            filtersSavedLists.remove(at: isFilteredIndex)
        }
        
        // Remove Names for filters
        let isFilteredNameIndex = filtersList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.filterValue.lowercased() == restaurantRequestWithNameFilter.filterValue?.lowercased()
        })
        
        if let isFilteredNameIndex = isFilteredNameIndex {
            filtersLists.remove(at: isFilteredNameIndex)
        }
        completion(filtersLists,filtersSavedLists)
    }
}

