//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/08/2023.
//

import Foundation
import Combine
import SmilesSharedServices
import SmilesUtilities
import SmilesOffers
import SmilesBanners
import SmilesLocationHandler
import NetworkingLayer

class SmilesExplorerHomeViewModel: NSObject {
    
    // MARK: - PROPERTIES -
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - VIEWMODELS -
    private let sectionsViewModel = SectionsViewModel()
    private let rewardPointsViewModel = RewardPointsViewModel()
    private let smilesExplorerGetOffersViewModel = SmilesExplorerGetOffersViewModel()
    
    private var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private var rewardPointsUseCaseInput: PassthroughSubject<RewardPointsViewModel.Input, Never> = .init()
    private var exclusiveOffersUseCaseInput: PassthroughSubject<SmilesExplorerGetOffersViewModel.Input, Never> = .init()
    
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
extension SmilesExplorerHomeViewModel {
    
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSections(categoryID: let categoryID, let type):
                self?.bind(to: self?.sectionsViewModel ?? SectionsViewModel())
                self?.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser, type: type))
                
            case .getRewardPoints:
                
                self?.bind(to: self?.rewardPointsViewModel ?? RewardPointsViewModel())
                self?.rewardPointsUseCaseInput.send(.getRewardPoints(baseUrl: AppCommonMethods.serviceBaseUrl))
                
            case .exclusiveDeals(categoryId: let categoryId, tag: let tag, pageNo: _):
                
                self?.bind(to: self?.smilesExplorerGetOffersViewModel ?? SmilesExplorerGetOffersViewModel())
                self?.exclusiveOffersUseCaseInput.send(.getExclusiveOffersList(categoryId: categoryId, tag: tag))
                
            case .getTickets(categoryId: let categoryId, tag: let tag, pageNo: _):
                
                self?.bind(to: self?.smilesExplorerGetOffersViewModel ?? SmilesExplorerGetOffersViewModel())
                self?.exclusiveOffersUseCaseInput.send(.getTickets(categoryId: categoryId, tag: tag))
            
            case .getBogo(categoryId: let categoryId, tag: let tag, pageNo: _):
            
                self?.bind(to: self?.smilesExplorerGetOffersViewModel ?? SmilesExplorerGetOffersViewModel())
                self?.exclusiveOffersUseCaseInput.send(.getBogo(categoryId: categoryId, tag: tag))
                
            case .getSubscriptionBannerDetails:
                self?.getSubscriptionBannerDetails()
            default:
                break
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
    
    private func getSubscriptionBannerDetails() {
        
        let request = ExplorerSubscriptionBannerRequest()
        
        let service = ExplorerHomeRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .getSubscriptionBannerDetails
        )
        
        service.getSubscriptionBannerDetails(request: request)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchSubscriptionBannerDetailsDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                self?.output.send(.fetchSubscriptionBannerDetailsDidSucceed(response: response))
            }
        .store(in: &cancellables)
        
    }
    
}


