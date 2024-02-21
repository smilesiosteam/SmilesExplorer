//
//  SubscriptionBannerUseCase.swift
//  Created by Habib Rehman on 12/02/2024.
//


import Foundation
import Combine
import SmilesOffers


protocol SubscriptionBannerUseCaseProtocol {
    func getSubscriptionBannerDetails() -> AnyPublisher<SubscriptionBannerUseCase.State, Never>
}

public class SubscriptionBannerUseCase: SubscriptionBannerUseCaseProtocol {
    
    // MARK: - Properties
    private let services: SmilesTouristServiceHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(services: SmilesTouristServiceHandlerProtocol) {
        self.services = services
    }
    
    // MARK: - Subscription Banner
    func getSubscriptionBannerDetails() -> AnyPublisher<State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.getSubscriptionBannerDetails()
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.fetchSubscriptionBannerDetailDidFail(error: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    promise(.success(.fetchSubscriptionBannerDetailDidSucceed(response:response)))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
    }
    
}


extension SubscriptionBannerUseCase {
    enum State {
        case fetchSubscriptionBannerDetailDidSucceed(response: ExplorerSubscriptionBannerResponse)
        case fetchSubscriptionBannerDetailDidFail(error: String)
    }
}

