//
//  SmilesTouristHomeViewModel.swift
//
//
//  Created by Habib Rehman on 23/01/2024.
//

import Foundation
import Combine
import SmilesUtilities
import SmilesSharedServices
import NetworkingLayer
import SmilesOffers
import SmilesBanners

final class SmilesTouristHomeViewModel {
    
    // MARK: - Output
    public enum Output {
        case fetchSectionsDidSucceed(response: GetSectionsResponseModel)
        case fetchSectionsDidFail(error: Error)
        
        case fetchTopOffersDidSucceed(response: GetTopOffersResponseModel)
        case fetchTopOffersDidFail(error: Error)
        
        case fetchRewardPointsDidSucceed(response: RewardPointsResponseModel, shouldLogout: Bool?)
        case fetchRewardPointsDidFail(error: Error)
        
        case fetchExclusiveOffersDidSucceed(response: OffersCategoryResponseModel)
        case fetchExclusiveOffersDidFail(error: Error)
        
        case fetchTicketsDidSucceed(response: OffersCategoryResponseModel)
        case fetchTicketDidFail(error: Error)
        
        case fetchBogoOffersDidSucceed(response: OffersCategoryResponseModel)
        case fetchBogoOffersDidFail(error: Error)
        
        case updateHeaderView
        
        case updateWishlistStatusDidSucceed(response: WishListResponseModel)
        case updateWishlistStatusDidFail(error: Error)
        
        case emptyOffersListDidSucceed
        
        case fetchFiltersDataSuccess(filters: [FiltersCollectionViewCellRevampModel], selectedSortingTableViewCellModel: FilterDO?)
        case fetchAllSavedFiltersSuccess(filtersList: [RestaurantRequestFilter], filtersSavedList: [RestaurantRequestWithNameFilter])
        
        case fetchSubscriptionBannerDetailsDidSucceed(response: ExplorerSubscriptionBannerResponse)
        case fetchSubscriptionBannerDetailsDidFail(error: Error)
        
    }
    
    // MARK: - Properties
    var output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    public var filtersSavedList: [RestaurantRequestWithNameFilter]?
    public var filtersList: [RestaurantRequestFilter]?
    public var selectedSort: String?
    public var selectedSortingTableViewCellModel: FilterDO?
    
    // MARK: - UseCases
    private let offerUseCase: OffersListUseCaseProtocol
    private let subscriptionUseCase: ExplorerSubscriptionUseCaseProtocol
    private let filtersUseCase: FiltersUseCaseProtocol
    private let sectionsUseCase: SectionsUseCaseProtocol
    public let rewardPointUseCase: RewardPointUseCaseProtocol
    public let wishListUseCase: WishListUseCaseProtocol
    public let subscriptionBannerUseCase: SubscriptionBannerUseCaseProtocol
    
    public var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    public var rewardPointsUseCaseInput: PassthroughSubject<RewardPointsViewModel.Input, Never> = .init()
    public var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    // MARK: - Delegate
    private let sectionsViewModel = SectionsViewModel()
    
    var personalizationEventSource:String?
    var categoryId:Int?
    var isGuestUser:Bool?
    var isUserSubscribed:Bool?
    var subscriptionType:ExplorerPackage?
    var voucherCode:String?
    var rewardPointIcon:String?
    var rewardPoint:Int?
    var platinumLimiReached:Bool?
    // MARK: - Init
    init(offerUseCase: OffersListUseCaseProtocol,
         subscriptionUseCase: ExplorerSubscriptionUseCaseProtocol,
         filtersUseCase:FiltersUseCaseProtocol,sectionsUseCase:SectionsUseCaseProtocol,rewardPointUseCase:RewardPointUseCaseProtocol,wishListUseCase:WishListUseCaseProtocol,subscriptionBannerUseCase:SubscriptionBannerUseCaseProtocol) {
        self.offerUseCase = offerUseCase
        self.subscriptionUseCase = subscriptionUseCase
        self.filtersUseCase = filtersUseCase
        self.sectionsUseCase = sectionsUseCase
        self.rewardPointUseCase = rewardPointUseCase
        self.wishListUseCase = wishListUseCase
        self.subscriptionBannerUseCase = subscriptionBannerUseCase
    }
}

//MARK: - UseCases Api Calling
extension SmilesTouristHomeViewModel {
    
    // MARK: - Get Offers API
    func getOffers(tag: SectionTypeTag, pageNo: Int = 1, categoryTypeIdsList: [String]? = nil){
        
        self.offerUseCase.getOffers(categoryId: self.categoryId, tag: tag, pageNo: pageNo, categoryTypeIdsList: categoryTypeIdsList)
            .sink { [weak self] state in
                guard let self = self else {return}
                switch state {
                case .fetchOffersDidSucceed(response: let response):
                    switch tag {
                    case .tickets:
                        self.output.send(.fetchTicketsDidSucceed(response: response))
                    case .exclusiveDeals:
                        self.output.send(.fetchExclusiveOffersDidSucceed(response: response))
                    case .bogoOffers:
                        self.output.send(.fetchBogoOffersDidSucceed(response: response))
                    }
                case .offersDidFail(error: let error):
                    debugPrint(error.localizedString)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Get Sections(UNSUBSCRIBED) API
    func getSections(){
        self.sectionsUseCase.getSections(categoryID: self.categoryId, type: ExplorerSubscriptionTypeConstant.unsubscribed, explorerPackageType: nil, freeTicketAvailed: nil, platinumLimitReached: nil)
            .sink { [weak self] state in
                guard self != nil else {
                    return
                }
                switch state {
                case .sectionsDidSucceed(response: let response):
                    print(response)
                    self?.output.send(.fetchSectionsDidSucceed(response: response))
                case .sectionsDidFail(error: let error):
                    self?.output.send(.fetchTicketDidFail(error: error))
                    debugPrint(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
        
    }
    // MARK: - Get Sections(SUBSCRIBED) API
    func getSections(type: String? = nil, explorerPackageType: ExplorerPackage? = nil, freeTicketAvailed:Bool? = nil, platinumLimiReached: Bool? = nil){
        self.sectionsUseCase.getSections(categoryID: self.categoryId, type: type, explorerPackageType: explorerPackageType, freeTicketAvailed: freeTicketAvailed, platinumLimitReached: platinumLimiReached)
            .sink { [weak self] state in
                guard self != nil else {
                    return
                }
                switch state {
                case .sectionsDidSucceed(response: let response):
                    print(response)
                    self?.output.send(.fetchSectionsDidSucceed(response: response))
                case .sectionsDidFail(error: let error):
                    self?.output.send(.fetchTicketDidFail(error: error))
                    debugPrint(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Get SubscriptionBanner Details API
    func getSubscriptionBannerDetails(){
        self.subscriptionBannerUseCase.getSubscriptionBannerDetails()
            .sink { [weak self] state in
                guard self != nil else {
                    return
                }
                switch state {
                case .fetchSubscriptionBannerDetailDidSucceed(response: let response):
                    print(response)
                    self?.output.send(.fetchSubscriptionBannerDetailsDidSucceed(response: response))
                case .fetchSubscriptionBannerDetailDidFail(error: let error):
                    self?.output.send(.fetchSubscriptionBannerDetailsDidFail(error: error))
                    debugPrint(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UpdateWishlist API
    func updateOfferWishlistStatus(operation: Int, offerId: String){
        self.wishListUseCase.updateOfferWishlistStatus(operation: operation, offerId: offerId)
            .sink { [weak self] state in
                guard self != nil else {
                    return
                }
                switch state {
                case .updateWishlistStatusDidSucceed(response: let response):
                    print(response)
                    self?.output.send(.updateWishlistStatusDidSucceed(response: response))
                case .updateWishlistDidFail(error: let error):
                    self?.output.send(.updateWishlistStatusDidFail(error: error))
                    debugPrint(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - RewardPoint API
    func getRewardPoint(){
        self.rewardPointUseCase.getRewardPoints()
            .sink { [weak self] state in
                guard self != nil else {
                    return
                }
                switch state {
                case .fetchRewardPointsDidSucceed(response: let response, shouldLogout: let logout):
                    print(response)
                    self?.output.send(.fetchRewardPointsDidSucceed(response: response, shouldLogout: logout))
                case .fetchRewardPointsDidFail(error: let error):
                    self?.output.send(.fetchRewardPointsDidFail(error: error))
                    debugPrint(error.localizedDescription)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Get Filters Data
    func getFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?){
        self.filtersUseCase.createFilters(filtersSavedList: filtersSavedList, isFilterAllowed: isFilterAllowed, isSortAllowed: isSortAllowed)
            .sink { [weak self] state in
                guard self != nil else {
                    return
                }
                switch state {
                case .filtersDidSucceed(response: let filters):
                    print(filters)
                    self?.output.send(.fetchFiltersDataSuccess(filters: filters, selectedSortingTableViewCellModel: self?.selectedSortingTableViewCellModel))
                }
            }
            .store(in: &cancellables)
    }
    // MARK: - Empty Offers
    func emptyOffers(){
        self.filtersUseCase.emptyOffersList()
            .sink { [weak self] state in
                guard self != nil else {
                    return
                }
                switch state {
                case .emptyOffersListDidSucceed:
                    self?.output.send(.emptyOffersListDidSucceed)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Remove And Save Filters
    func removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel) {
        
        if let filtersSavedList = filtersSavedList {
            self.filtersSavedList = filtersSavedList
        }
        if let filtersList = filtersList {
            self.filtersList = filtersList
        }
        // Remove all saved Filters
        let isFilteredIndex = filtersSavedList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.name.lowercased() == restaurantRequestWithNameFilter.filterName?.lowercased()
        })
        
        if let isFilteredIndex = isFilteredIndex {
            self.filtersSavedList?.remove(at: isFilteredIndex)
        }
        
        // Remove Names for filters
        let isFilteredNameIndex = filtersList?.firstIndex(where: { (restaurantRequestWithNameFilter) -> Bool in
            filter.filterValue.lowercased() == restaurantRequestWithNameFilter.filterValue?.lowercased()
        })
        
        if let isFilteredNameIndex = isFilteredNameIndex {
            self.filtersList?.remove(at: isFilteredNameIndex)
        }
        
        self.output.send(.fetchAllSavedFiltersSuccess(filtersList: self.filtersList ?? [], filtersSavedList: self.filtersSavedList ?? []))
    }
    // MARK: - Set Filters to be Removed
    func setFiltersSavedList(filtersSavedList: [RestaurantRequestWithNameFilter]?, filtersList: [RestaurantRequestFilter]?) {
        self.filtersSavedList = filtersSavedList
        self.filtersList = filtersList
    }
    
    
}

