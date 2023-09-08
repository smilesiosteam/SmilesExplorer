
//  Created by Habib Rehman on 04/09/2023.
//

import Foundation


import Foundation
import Combine
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesBanners
import SmilesLocationHandler

class SmilesExplorerHomeUpgradeViewModel: NSObject {
    
    // MARK: - PROPERTIES -
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - VIEWMODELS -
    private let sectionsViewModel = SectionsViewModel()
    private let rewardPointsViewModel = RewardPointsViewModel()
    private let smilesExplorerGetOffersViewModel = SmilesExplorerGetOffersViewModel()
    private let smilesExplorerGetOffersStoriesViewModel = SmilesExplorerGetOffersStoriesViewModel()
    private let wishListViewModel = WishListViewModel()
    
    private let smilesExplorerGetBogoOffersViewModel = SmilesExplorerGetBogoOffersViewModel()
    private var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    
    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private var rewardPointsUseCaseInput: PassthroughSubject<RewardPointsViewModel.Input, Never> = .init()
    private var exclusiveOffersUseCaseInput: PassthroughSubject<SmilesExplorerGetOffersViewModel.Input, Never> = .init()
    private var exclusiveOffersStoriesUseCaseInput: PassthroughSubject<SmilesExplorerGetOffersStoriesViewModel.Input, Never> = .init()
    private var bogoOffersUseCaseInput: PassthroughSubject<SmilesExplorerGetBogoOffersViewModel.Input, Never> = .init()
    
    private var filtersSavedList: [RestaurantRequestWithNameFilter]?
    private var filtersList: [RestaurantRequestFilter]?
    private var selectedSortingTableViewCellModel: FilterDO?
    private var selectedSort: String?
    
    // MARK: - METHODS -
    private func logoutUser() {
        UserDefaults.standard.set(false, forKey: .notFirstTime)
        UserDefaults.standard.set(true, forKey: .isLoggedOut)
        UserDefaults.standard.removeObject(forKey: .loyaltyID)
        LocationStateSaver.removeLocation()
        LocationStateSaver.removeRecentLocations()
    }
    
}

// MARK: - VIEWMODELS BINDINGS -
extension SmilesExplorerHomeUpgradeViewModel {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSections(categoryID: let categoryID, let type, let explorerPackageType):
                self?.bind(to: self?.sectionsViewModel ?? SectionsViewModel())
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser, type: type, explorerPackageType:explorerPackageType))
                
            case .getFiltersData(let filtersSavedList, let isFilterAllowed, let isSortAllowed):
                break
                
            case .removeAndSaveFilters(let filter):
                self?.removeAndSaveFilters(filter: filter)
                
            case .getSortingList:
                self?.output.send(.fetchSortingListDidSucceed)
                
            case .generateActionContentForSortingItems(let sortingModel):
                self?.generateActionContentForSortingItems(sortingModel: sortingModel)
                
                
            case .setFiltersSavedList(let filtersSavedList, let filtersList):
                self?.filtersSavedList = filtersSavedList
                self?.filtersList = filtersList
                
            case .setSelectedSort(let sortTitle):
                self?.selectedSort = sortTitle
                
//            case .getTopOffers(bannerType: let bannerType, categoryId: let categoryId):
//                self?.bind(to: self?.topOffersViewModel ?? TopOffersViewModel())
//                self?.topOffersUseCaseInput.send(.getTopOffers(menuItemType: nil, bannerType: bannerType, categoryId: categoryId, bannerSubType: nil, isGuestUser: false, baseUrl: AppCommonMethods.serviceBaseUrl))
            case .getRewardPoints:
                
                self?.bind(to: self?.rewardPointsViewModel ?? RewardPointsViewModel())
                self?.rewardPointsUseCaseInput.send(.getRewardPoints(baseUrl: AppCommonMethods.serviceBaseUrl))
                
            case .exclusiveDeals(categoryId: let categoryId, tag: let tag, pageNo: _):
                
                self?.bind(to: self?.smilesExplorerGetOffersViewModel ?? SmilesExplorerGetOffersViewModel())
                self?.exclusiveOffersUseCaseInput.send(.getExclusiveOffersList(categoryId: categoryId, tag: tag))
                
            case .getExclusiveDealsStories(let categoryId, let tag, let pageNo):
                self?.bind(to: self?.smilesExplorerGetOffersStoriesViewModel ?? SmilesExplorerGetOffersStoriesViewModel())
                self?.exclusiveOffersStoriesUseCaseInput.send(.getExclusiveOffersList(categoryId: categoryId, tag: tag.rawValue, pageNo: pageNo ?? 1))
                
            case .getTickets(categoryId: let categoryId, tag: let tag, pageNo: _):
                
                self?.bind(to: self?.smilesExplorerGetOffersViewModel ?? SmilesExplorerGetOffersViewModel())
                self?.exclusiveOffersUseCaseInput.send(.getTickets(categoryId: categoryId, tag: tag))
            
            case .getBogoOffers(categoryId: let categoryId, tag: let tag, pageNo: _):
            
//                self?.bind(to: self?.smilesExplorerGetOffersViewModel ?? SmilesExplorerGetOffersViewModel())
                self?.bind(to: self?.smilesExplorerGetBogoOffersViewModel ?? SmilesExplorerGetBogoOffersViewModel())
                self?.bogoOffersUseCaseInput.send(.getBogoOffers(categoryId: categoryId, tag: tag.rawValue))
                
            
            case .getBogo(categoryId: _, tag: _, pageNo: _):
                break
            case .updateOfferWishlistStatus(let operation, let offerId):
                self?.bind(to: self?.wishListViewModel ?? WishListViewModel())
                self?.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: AppCommonMethods.serviceBaseUrl))
            }
            
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func bind(to sectionsViewModel: SectionsViewModel) {
        sectionsUseCaseInput = PassthroughSubject<SectionsViewModel.Input, Never>()
        let output = sectionsViewModel.transform(input: sectionsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    debugPrint(sectionsResponse)
                    self?.output.send(.fetchSectionsDidSucceed(response: sectionsResponse))
                case .fetchSectionsDidFail(let error):
                    self?.output.send(.fetchSectionsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    func bind(to rewardPointsViewModel: RewardPointsViewModel) {
        rewardPointsUseCaseInput = PassthroughSubject<RewardPointsViewModel.Input, Never>()
        let output = rewardPointsViewModel.transform(input: rewardPointsUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchRewardPointsDidSucceed(let response, _):
                    if let responseCode = response.responseCode {
                        if responseCode == "101" || responseCode == "0000252" {
                            self?.logoutUser()
                            self?.output.send(.fetchRewardPointsDidSucceed(response: response, shouldLogout: true))
                        }
                    } else {
                        if response.totalPoints != nil {
                            self?.output.send(.fetchRewardPointsDidSucceed(response: response, shouldLogout: false))
                        }
                    }
                case .fetchRewardPointsDidFail(let error):
                    self?.output.send(.fetchRewardPointsDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    func bind(to exclusiveOffersViewMode: SmilesExplorerGetOffersViewModel) {
        exclusiveOffersUseCaseInput = PassthroughSubject<SmilesExplorerGetOffersViewModel.Input, Never>()
        let output = exclusiveOffersViewMode.transform(input: exclusiveOffersUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchExclusiveOffersDidSucceed(let response):
                    debugPrint(response)
                    self?.output.send(.fetchExclusiveOffersDidSucceed(response: response))
                case .fetchExclusiveOffersDidFail(error: let error):
                    self?.output.send(.fetchExclusiveOffersDidFail(error: error))
                case .fetchTicketsDidSucceed(response: let response):
                    self?.output.send(.fetchTicketsDidSucceed(response: response))
                case .fetchTicketDidFail(error: let error):
                    self?.output.send(.fetchTicketDidFail(error: error))
                case .fetchBogoDidSucceed(response: let response):
                    self?.output.send(.fetchBogoDidSucceed(response: response))
                case .fetchBogoDidFail(error: let error):
                    self?.output.send(.fetchBogoDidFail(error: error))
                    
                    
                }
            }.store(in: &cancellables)
    }
    
    func bind(to exclusiveOffersStoriesViewModel: SmilesExplorerGetOffersStoriesViewModel) {
        exclusiveOffersStoriesUseCaseInput = PassthroughSubject<SmilesExplorerGetOffersStoriesViewModel.Input, Never>()
        let output = exclusiveOffersStoriesViewModel.transform(input: exclusiveOffersStoriesUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchExclusiveOffersDidSucceed(let response):
                    debugPrint(response)
                    self?.output.send(.fetchExclusiveOffersStoriesDidSucceed(response: response))
                case .fetchExclusiveOffersDidFail(error: let error):
                    self?.output.send(.fetchExclusiveOffersStoriesDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    func bind(to bogoOffersViewModel: SmilesExplorerGetBogoOffersViewModel) {
        bogoOffersUseCaseInput = PassthroughSubject<SmilesExplorerGetBogoOffersViewModel.Input, Never>()
        let output = bogoOffersViewModel.transform(input: bogoOffersUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchBogoOffersDidSucceed(response: let response):
                    debugPrint(response)
                    self?.output.send(.fetchBogoOffersDidSucceed(response: response))
                case .fetchBogoOffersDidFail(error: let error):
                    self?.output.send(.fetchBogoOffersDidFail(error: error))
                }
            }.store(in: &cancellables)
    }
    
    
    //MARK: -  WishList ViewModel Binding
    func bind(to wishListViewModel: WishListViewModel) {
        wishListUseCaseInput = PassthroughSubject<WishListViewModel.Input, Never>()
        let output = wishListViewModel.transform(input: wishListUseCaseInput.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .updateWishlistStatusDidSucceed(response: let response):
                    self?.output.send(.updateWishlistStatusDidSucceed(response: response))
                case .updateWishlistDidFail(error: let error):
                    debugPrint(error)
                    break
                }
            }.store(in: &cancellables)
    }
}

extension SmilesExplorerHomeUpgradeViewModel {
    // Create Filters Data
    func createFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?) {
        var filters = [FiltersCollectionViewCellRevampModel]()
        
        // Filter List
        var firstFilter = FiltersCollectionViewCellRevampModel(name: "Filters".localizedString, leftImage: "", rightImage: "filter-revamp", filterCount: filtersSavedList?.count ?? 0)
        
        let firstFilterRowWidth = AppCommonMethods.getAutoWidthWith(firstFilter.name, font: .circularXXTTBookFont(size: 14), additionalWidth: 60)
        firstFilter.rowWidth = firstFilterRowWidth
        
        let sortByTitle = !self.selectedSort.asStringOrEmpty().isEmpty ? "\("SortbyTitle".localizedString): \(self.selectedSort.asStringOrEmpty())" : "\("SortbyTitle".localizedString)"
        var secondFilter = FiltersCollectionViewCellRevampModel(name: sortByTitle, leftImage: "", rightImage: "sortby-chevron-down", rightImageWidth: 0, rightImageHeight: 4, tag: RestaurantFiltersType.deliveryTime.rawValue)
        
        let secondFilterRowWidth = AppCommonMethods.getAutoWidthWith(secondFilter.name, font: .circularXXTTBookFont(size: 14), additionalWidth: 40)
        secondFilter.rowWidth = secondFilterRowWidth
        
        if isFilterAllowed != 0 {
            filters.append(firstFilter)
        }
        
        if isSortAllowed != 0 {
            filters.append(secondFilter)
        }
        
        if let appliedFilters = filtersSavedList, appliedFilters.count > 0 {
            for filter in appliedFilters {
                
                let width = AppCommonMethods.getAutoWidthWith(filter.filterName.asStringOrEmpty(), font: .circularXXTTMediumFont(size: 22), additionalWidth: 30)
                
                let model = FiltersCollectionViewCellRevampModel(name: filter.filterName.asStringOrEmpty(), leftImage: "", rightImage: "filters-cross", isFilterSelected: true, filterValue: filter.filterValue.asStringOrEmpty(), tag: 0, rowWidth: width)

                filters.append(model)

            }
        }
        
        self.output.send(.fetchFiltersDataSuccess(filters: filters, selectedSortingTableViewCellModel: self.selectedSortingTableViewCellModel)) // Send filters back to VC
    }
    
    // Get saved filters
//    func getSavedFilters() -> [RestaurantRequestFilter] {
//        if let savedFilters = UserDefaults.standard.object([RestaurantRequestWithNameFilter].self, with: FilterDictTags.FiltersDict.rawValue) {
//            if savedFilters.count > 0 {
//                let uniqueUnordered = Array(Set(savedFilters))
//
//                filtersSavedList = uniqueUnordered
//
//                filtersList = [RestaurantRequestFilter]()
//
//                if let savedFilters = filtersSavedList {
//                    for filter in savedFilters {
//                        let restaurantRequestFilter = RestaurantRequestFilter()
//                        restaurantRequestFilter.filterKey = filter.filterKey
//                        restaurantRequestFilter.filterValue = filter.filterValue
//
//                        filtersList?.append(restaurantRequestFilter)
//                    }
//                }
//
//                defer {
//                    self.output.send(.fetchSavedFiltersAfterSuccess(filtersSavedList: filtersSavedList ?? []))
//                }
//
//                return filtersList ?? []
//
//            }
//        }
//        return []
//    }
    
    func removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel) {
        // Remove all saved Filters
        let isFilteredIndex = filtersSavedList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.name.lowercased() == restaurantRequestWithNameFilter.filterName?.lowercased()
        })
        
        if let isFilteredIndex = isFilteredIndex {
            filtersSavedList?.remove(at: isFilteredIndex)
        }
        
        // Remove Names for filters
        let isFilteredNameIndex = filtersList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.filterValue.lowercased() == restaurantRequestWithNameFilter.filterValue?.lowercased()
        })
        
        if let isFilteredNameIndex = isFilteredNameIndex {
            filtersList?.remove(at: isFilteredNameIndex)
        }
        
//        self.output.send(.emptyOffersListDidSucceed)
        self.output.send(.fetchAllSavedFiltersSuccess(filtersList: filtersList ?? [], filtersSavedList: filtersSavedList ?? []))
    }
    
    func generateActionContentForSortingItems(sortingModel: GetSortingListResponseModel?) {
        var items = [BaseRowModel]()
        
        if let sortingList = sortingModel?.sortingList, sortingList.count > 0 {
            for (index, sorting) in sortingList.enumerated() {
                if let sortingModel = selectedSortingTableViewCellModel {
                    if sortingModel.name?.lowercased() == sorting.name?.lowercased() {
                        if index == sortingList.count - 1 {
                            addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: true)
                        } else {
                            addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: false)
                        }
                    } else {
                        if index == sortingList.count - 1 {
                            addSortingItems(items: &items, sorting: sorting, isSelected: false, isBottomLineHidden: true)
                        } else {
                            addSortingItems(items: &items, sorting: sorting, isSelected: false, isBottomLineHidden: false)
                        }
                    }
                } else {
                    selectedSortingTableViewCellModel = FilterDO()
                    selectedSortingTableViewCellModel = sorting
                    if index == sortingList.count - 1 {
                        addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: true)
                    } else {
                        addSortingItems(items: &items, sorting: sorting, isSelected: true, isBottomLineHidden: false)
                    }
                }
            }
        }
        
        self.output.send(.fetchContentForSortingItems(baseRowModels: items))
    }
    
    func addSortingItems(items: inout [BaseRowModel], sorting: FilterDO, isSelected: Bool, isBottomLineHidden: Bool) {
//        items.append(SortingTableViewCell.rowModel(model: SortingTableViewCellModel(title: sorting.name.asStringOrEmpty(), mode: .SingleSelection, isSelected: isSelected, multiChoiceUpTo: 1, isSelectionMandatory: true, sortingModel: sorting, bottomLineHidden: isBottomLineHidden)))
    }
}


