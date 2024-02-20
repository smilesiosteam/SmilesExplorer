//
//  File.swift
//  
//
//  Created by Habib Rehman on 16/02/2024.
//

import Foundation
import SmilesOffers
import Combine
import NetworkingLayer

final public class OffersDetailViewModel {
    
    // MARK: - PROPERTIES -
    let offerId: String?
    let imageURL: String?
    
    private let offerUseCase: OffersDetailUseCaseProtocol
    private var statusSubject = PassthroughSubject<State, Never>()
    var offersDetailPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - METHODS -
    init(offerUseCase: OffersDetailUseCaseProtocol,offerId:String,imageURL:String) {
        self.offerUseCase = offerUseCase
        self.offerId = offerId
        self.imageURL = imageURL
    }
    
}

// MARK: - OFFERS API BINDING -
extension OffersDetailViewModel {
    
    func getOffers() {
        self.offerUseCase.getOffersDetail(offerId: self.offerId)
            .sink { [weak self] state in
                switch state {
                case .fetchOffersDetailDidSucceed(let response):
                    self?.statusSubject.send(.fetchOffersDetailDidSucceed(response: response))
                case .fetchOffersDetailDidFail(let error):
                    self?.statusSubject.send(.fetchOffersDetailDidFail(error: error))
                }
            }
            .store(in: &cancellables)
    }
    
}

// MARK: - VIEW MODEL STATE -
extension OffersDetailViewModel {
    
    enum State {
        case fetchOffersDetailDidSucceed(response: OfferDetailsResponse)
        case fetchOffersDetailDidFail(error: NetworkError)
    }
    
}
