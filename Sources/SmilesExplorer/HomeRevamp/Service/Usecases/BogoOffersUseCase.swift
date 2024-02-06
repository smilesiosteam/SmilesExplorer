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

protocol BogoOffersUseCaseProtocol {
    func getBogoOffers(categoryId: Int?, tag: String?, pageNo: Int,categoryTypeIdsList: [String]?) -> AnyPublisher<BogoOffersUseCase.State, Never>
}

public class BogoOffersUseCase: BogoOffersUseCaseProtocol {
    
    // MARK: - Properties
    private let services: SmilesTouristServiceHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(services: SmilesTouristServiceHandlerProtocol) {
        self.services = services
    }
    
    // MARK: - getBogoOffers
    func getBogoOffers(categoryId: Int?, tag: String?, pageNo: Int, categoryTypeIdsList: [String]?) -> AnyPublisher<State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.getBogoOffers(categoryId: categoryId, tag: tag, pageNo: pageNo)
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


extension BogoOffersUseCase {
    enum State {
        case success(response: OffersCategoryResponseModel)
        case failure(message: String)
    }
}
