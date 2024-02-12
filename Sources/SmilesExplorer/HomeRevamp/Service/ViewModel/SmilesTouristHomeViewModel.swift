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
        case getOffersWithFilters(categoryId: Int?, tag: SectionTypeTag,pageNo:Int?, categoryTypeIdsList: [String]? = nil)
        
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
        
    }
    
    // MARK: - Properties
    var output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    public var filtersSavedList: [RestaurantRequestWithNameFilter]?
    public var filtersList: [RestaurantRequestFilter]?
    public var selectedSort: String?
    public var selectedSortingTableViewCellModel: FilterDO?
    
    // MARK: - UseCases
    private let faqsViewModel = FAQsViewModel()
    private let offerUseCase: OffersListUseCaseProtocol
    private let subscriptionUseCase: SmilesExplorerSubscriptionUseCaseProtocol
    private let filtersUseCaseProtocol: FiltersUseCaseProtocol
    public var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private var faqsUseCaseInput: PassthroughSubject<FAQsViewModel.Input, Never> = .init()
    public var rewardPointsUseCaseInput: PassthroughSubject<RewardPointsViewModel.Input, Never> = .init()
    public var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    // MARK: - Delegate
    var navigationDelegate: SmilesExplorerHomeDelegate?
    
    // MARK: - Init
    init(offerUseCase: OffersListUseCaseProtocol,
         subscriptionUseCase: SmilesExplorerSubscriptionUseCaseProtocol,
         filtersUseCaseProtocol:FiltersUseCaseProtocol) {
        self.offerUseCase = offerUseCase
        self.subscriptionUseCase = subscriptionUseCase
        self.filtersUseCaseProtocol = filtersUseCaseProtocol
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
                self?.getOffers(categoryId: categoryId, tag: tag, pageNo: pageNo)
                
            case .getOffersWithFilters(categoryId: let categoryId, tag: let tag, pageNo: let pageNo, categoryTypeIdsList: let categoryTypeIdsList):
                self?.getOffers(categoryId: categoryId ?? 973, tag: tag, pageNo: pageNo ?? 0,categoryTypeIdsList: categoryTypeIdsList ?? [])
            
            case .getFiltersData(filtersSavedList: let filtersSavedList, isFilterAllowed: let isFilterAllowed, isSortAllowed: let isSortAllowed):
                self?.filtersUseCaseProtocol.createFilters(filtersSavedList: filtersSavedList, isFilterAllowed: isFilterAllowed, isSortAllowed: isSortAllowed) { filters in
                    self?.output.send(.fetchFiltersDataSuccess(filters: filters, selectedSortingTableViewCellModel: self?.selectedSortingTableViewCellModel))
                }
            
            case .removeAndSaveFilters(filtersList: let filtersList, filtersSavedList: let filtersSavedList, filter: let filter):
                self?.filtersUseCaseProtocol.removeAndSaveFilters(filtersList: filtersList, filtersSavedList: filtersSavedList, filter: filter, completion: { filtersList, filtersSavedList in
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
    func getOffers(categoryId: Int, tag: SectionTypeTag, pageNo: Int, categoryTypeIdsList: [String]? = nil){
        self.offerUseCase.getOffers(categoryId: categoryId, tag: tag, pageNo: pageNo, categoryTypeIdsList: categoryTypeIdsList)
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
                    default: break
                    }
                case .offersDidFail(error: let error):
                    debugPrint(error.localizedString)
                }
            }
            .store(in: &cancellables)
    }
    
}

