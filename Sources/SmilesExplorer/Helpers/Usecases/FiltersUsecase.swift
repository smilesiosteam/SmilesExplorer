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
import SmilesReusableComponents

protocol FiltersUseCaseProtocol {
    func createFilters(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?) -> AnyPublisher<FiltersUseCase.GetFiltersState, Never>
    func emptyOffersList() -> AnyPublisher<FiltersUseCase.GetEmptyOffersState, Never>
}


final class FiltersUseCase: FiltersUseCaseProtocol {
    
    // MARK: - Create Filters Data For SmileTourist
    func createFilters(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?) -> AnyPublisher<FiltersUseCase.GetFiltersState, Never>  {
        
        return Future<GetFiltersState, Never> { [weak self] promise in
            guard self != nil else {
                return
            }
            
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
            promise(.success(.filtersDidSucceed(response: filters)))
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - emptyOffersList
    func emptyOffersList() -> AnyPublisher<FiltersUseCase.GetEmptyOffersState, Never> {
        return Future<GetEmptyOffersState, Never> { [weak self] promise in
            guard self != nil else {
                return
            }
            promise(.success(.emptyOffersListDidSucceed))
        }.eraseToAnyPublisher()
    }
}


extension FiltersUseCase {
    enum GetFiltersState {
        case filtersDidSucceed(response: [FiltersCollectionViewCellRevampModel])
    }
    
    enum GetEmptyOffersState {
        case emptyOffersListDidSucceed
    }
}

