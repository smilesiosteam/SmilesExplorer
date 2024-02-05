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
        case getSections(categoryID: Int, type: String, explorerPackageType:ExplorerPackage,freeTicketAvailed:Bool,platinumLimiReached: Bool? = nil)
        case exclusiveDeals(categoryId: Int?, tag: String?,pageNo:Int?)
        case getExclusiveDealsStories(categoryId: Int?, tag: SectionTypeTag, pageNo: Int?)
        case getTickets(categoryId: Int?, tag: String?,pageNo:Int?)
        case getBogo(categoryId: Int?, tag: String?,pageNo:Int?)
        case getBogoOffers(categoryId: Int?, tag: SectionTypeTag,pageNo:Int?, categoryTypeIdsList: [String]? = nil)
        case getFiltersData(filtersSavedList: [RestaurantRequestWithNameFilter]?, isFilterAllowed: Int?, isSortAllowed: Int?)
        case removeAndSaveFilters(filter: FiltersCollectionViewCellRevampModel)
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
        
        
    }
    
    // MARK: - Properties
    var output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    private let faqsViewModel = FAQsViewModel()
    private var faqsUseCaseInput: PassthroughSubject<FAQsViewModel.Input, Never> = .init()
    
    // MARK: - Init
    init() {
    }
}

//MARK: - EasyInsuranceViewModel Transformation
extension SmilesTouristHomeViewModel {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .emptyOffersList:
                break
            case .exclusiveDeals(categoryId: let categoryID, tag: let tag, pageNo: let pageNo):
                break
            case .getSections(categoryID: let categoryID, type: let type, explorerPackageType: let explorerPackageType, freeTicketAvailed: let freeTicketAvailed, platinumLimiReached: let platinumLimiReached):
                break
            case .getExclusiveDealsStories(categoryId: let categoryId, tag: let tag, pageNo: let pageNo):
                break
            case .getTickets(categoryId: let categoryId, tag: let tag, pageNo: let pageNo):
                break
            case .getBogo(categoryId: let categoryId, tag: let tag, pageNo: let pageNo):
                break
            case .getBogoOffers(categoryId: let categoryId, tag: let tag, pageNo: let pageNo, categoryTypeIdsList: let categoryTypeIdsList):
                break
            case .getFiltersData(filtersSavedList: let filtersSavedList, isFilterAllowed: let isFilterAllowed, isSortAllowed: let isSortAllowed):
                break
            case .removeAndSaveFilters(filter: let filter):
                break
            }
            
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
}

//MARK: - DATA BINDING 
extension SmilesTouristHomeViewModel {
//    func bind(to faqsViewModel: FAQsViewModel) {
//        faqsUseCaseInput = PassthroughSubject<FAQsViewModel.Input, Never>()
//        let output = faqsViewModel.transform(input: faqsUseCaseInput.eraseToAnyPublisher())
//        output
//            .sink { [weak self] event in
//                switch event {
//                case .fetchFAQsDidSucceed(let response):
//                    self?.output.send(.fetchFAQsDidSucceed(response: response))
//                case .fetchFAQsDidFail(let error):
//                    self?.output.send(.fetchFAQsDidFail(error: error))
//                }
//            }.store(in: &cancellables)
//    }
    
}
