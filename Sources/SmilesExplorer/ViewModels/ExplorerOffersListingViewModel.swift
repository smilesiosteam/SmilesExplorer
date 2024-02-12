//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 12/02/2024.
//

import Foundation
import SmilesOffers
import Combine

final class ExplorerOffersListingViewModel {
    
    // MARK: - PROPERTIES -
    private let offerUseCase: OffersListUseCaseProtocol
    private var statusSubject = PassthroughSubject<State, Never>()
    var orderStatusPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - METHODS -
    init(offerUseCase: OffersListUseCaseProtocol) {
        self.offerUseCase = offerUseCase
    }
    
}

// MARK: - OFFERS API BINDING -
extension ExplorerOffersListingViewModel {
    
    func getOffers(categoryId: Int, tag: SectionTypeTag, pageNo: Int) {
        offerUseCase.getOffers(categoryId: categoryId, tag: tag, pageNo: pageNo, categoryTypeIdsList: nil)
            .sink { [weak self] state in
                switch state {
                case .fetchOffersDidSucceed(let response):
                    self?.statusSubject.send(.fetchOffersDidSucceed(response: response))
                case .offersDidFail(let error):
                    self?.statusSubject.send(.offersDidFail(error: error))
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - VIEW MODEL STATE -
extension ExplorerOffersListingViewModel {
    
    enum State {
        case fetchOffersDidSucceed(response: OffersCategoryResponseModel)
        case offersDidFail(error: String)
    }
    
}
