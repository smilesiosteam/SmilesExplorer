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
    
    // MARK: - Input
    public enum Input {
        case emptyOffersList
        case getRewardPoints
        case getSections(categoryID: Int, type: String, explorerPackageType:ExplorerPackage,freeTicketAvailed:Bool,platinumLimitReached: Bool? = nil)
        case getOffers(categoryId: Int, tag: SectionTypeTag, pageNo: Int)
        
        //MARK: - Filtered Offers
        case getFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?)
        case removeAndSaveFilters(filtersList: [RestaurantRequestFilter]?, filtersSavedList: [RestaurantRequestWithNameFilter]?,filter: FiltersCollectionViewCellRevampModel)
        case setFiltersSavedList(filtersSavedList: [RestaurantRequestWithNameFilter]?, filtersList: [RestaurantRequestFilter]?)
        //MARK: - Favourite
        case updateOfferWishlistStatus(operation: Int, offerId: String)
        
    }
    
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
        
        case fetchExclusiveOffersStoriesDidSucceed(response: OffersCategoryResponseModel)
        case fetchExclusiveOffersStoriesDidFail(error: Error)
        
        case fetchTicketsDidSucceed(response: OffersCategoryResponseModel)
        case fetchTicketDidFail(error: Error)
        
        case fetchBogoDidSucceed(response: OffersCategoryResponseModel)
        case fetchBogoDidFail(error: Error)
        
        case fetchBogoOffersDidSucceed(response: OffersCategoryResponseModel)
        case fetchBogoOffersDidFail(error: Error)
        
        case updateHeaderView
        case updateWishlistStatusDidSucceed(response: WishListResponseModel)
        
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
    var navigationDelegate: SmilesExplorerHomeDelegate?
    private let sectionsViewModel = SectionsViewModel()

    var personalizationEventSource:String?
    let categoryId:Int?
    var isGuestUser:Bool?
    var isUserSubscribed:Bool?
    var subscriptionType:ExplorerPackage?
    var voucherCode:String?
    var delegate :SmilesExplorerHomeDelegate?
    var rewardPointIcon:String?
    var rewardPoint:Int?
    var platinumLimiReached:Bool?
    // MARK: - Init
    init(categoryId: Int, offerUseCase: OffersListUseCaseProtocol,
         subscriptionUseCase: ExplorerSubscriptionUseCaseProtocol,
         filtersUseCase:FiltersUseCaseProtocol,sectionsUseCase:SectionsUseCaseProtocol,rewardPointUseCase:RewardPointUseCaseProtocol,wishListUseCase:WishListUseCaseProtocol,subscriptionBannerUseCase:SubscriptionBannerUseCaseProtocol) {
        self.categoryId = categoryId
        self.offerUseCase = offerUseCase
        self.subscriptionUseCase = subscriptionUseCase
        self.filtersUseCase = filtersUseCase
        self.sectionsUseCase = sectionsUseCase
        self.rewardPointUseCase = rewardPointUseCase
        self.wishListUseCase = wishListUseCase
        self.subscriptionBannerUseCase = subscriptionBannerUseCase
    }
}

//MARK: - EasyInsuranceViewModel Transformation
extension SmilesTouristHomeViewModel {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .emptyOffersList:
                self?.output.send(.emptyOffersListDidSucceed)
                
            case .updateOfferWishlistStatus(operation: let operation, offerId: let offerId):
                self?.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: AppCommonMethods.serviceBaseUrl))
                
            case .getSections(categoryID: let categoryID, type: let type, explorerPackageType: let explorerPackageType, freeTicketAvailed: let freeTicketAvailed, platinumLimitReached: let platinumLimitReached):
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser, type: type, explorerPackageType:explorerPackageType,freeTicketAvailed:freeTicketAvailed,platinumLimitReached: platinumLimitReached))
           
            case .getOffers(categoryId: let categoryId, tag: let tag, pageNo: let pageNo):
//                self?.getOffers(categoryId: categoryId, tag: tag, pageNo: pageNo)
                break
                
            case .getFiltersData(filtersSavedList: let filtersSavedList, isFilterAllowed: let isFilterAllowed, isSortAllowed: let isSortAllowed):
                self?.filtersUseCase.createFilters(filtersSavedList: filtersSavedList, isFilterAllowed: isFilterAllowed, isSortAllowed: isSortAllowed) { filters in
                    self?.output.send(.fetchFiltersDataSuccess(filters: filters, selectedSortingTableViewCellModel: self?.selectedSortingTableViewCellModel))
                }
            
            case .removeAndSaveFilters(filtersList: let filtersList, filtersSavedList: let filtersSavedList, filter: let filter):
                self?.filtersUseCase.removeAndSaveFilters(filtersList: filtersList, filtersSavedList: filtersSavedList, filter: filter, completion: { filtersList, filtersSavedList in
                    self?.output.send(.fetchAllSavedFiltersSuccess(filtersList: filtersList, filtersSavedList: filtersSavedList))
                })
                
            case .setFiltersSavedList(filtersSavedList: let filtersSavedList, filtersList: let filtersList):
                self?.filtersSavedList = filtersSavedList
                self?.filtersList = filtersList
                
            case .getRewardPoints:
                self?.rewardPointsUseCaseInput.send(.getRewardPoints(baseUrl: AppCommonMethods.serviceBaseUrl))
                
            }
            
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    // MARK: - Get Offers
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
                        self.output.send(.fetchBogoDidSucceed(response: response))
                    }
                case .offersDidFail(error: let error):
                    debugPrint(error.localizedString)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Get Offers With Filters
    
    func getSections(){
        self.sectionsUseCase.getSections(categoryID: categoryId, baseUrl: nil, isGuestUser: nil, type: "UNSUBSCRIBED", explorerPackageType: nil, freeTicketAvailed: nil, platinumLimitReached: nil)
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
    
    
}

