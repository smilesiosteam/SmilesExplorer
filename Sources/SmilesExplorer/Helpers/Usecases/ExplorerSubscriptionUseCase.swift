//
//  File.swift
//  
//
//  Created by Habib Rehman on 05/02/2024.
//

import Foundation
import Combine
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers

protocol ExplorerSubscriptionUseCaseProtocol {
     func getSubscriptionInfo(packageType: String?) -> AnyPublisher<ExplorerSubscriptionUseCase.State, Never>
}

public class ExplorerSubscriptionUseCase: ExplorerSubscriptionUseCaseProtocol {
    
    // MARK: - Properties
    private let services: SmilesTouristServiceHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(services: SmilesTouristServiceHandlerProtocol) {
        self.services = services
    }
    
    // MARK: - getBogoOffers
    func getSubscriptionInfo(packageType: String?) -> AnyPublisher<ExplorerSubscriptionUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.getSubscriptionInfo(packageType)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.failure(message: error.localizedDescription)))
                    }
                
            } receiveValue: { response in
                debugPrint(response)
                promise(.success(.success(response: response)))
            }
            .store(in: &cancellables)

        }
        .eraseToAnyPublisher()
    }
  
}


extension ExplorerSubscriptionUseCase {
    enum State {
        case success(response: SmilesExplorerSubscriptionInfoResponse)
        case failure(message: String)
    }
}
