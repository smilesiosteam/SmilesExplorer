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

protocol OffersListUseCaseProtocol {
    func getOffers(categoryId: Int?, tag: SectionTypeTag?, pageNo: Int?) -> AnyPublisher<OffersListUseCase.State, Never>
    func getOffersWithFilters(categoryId: Int?, tag: SectionTypeTag?, pageNo: Int?,categoryTypeIdsList: [String]?) -> AnyPublisher<OffersListUseCase.State, Never>
}

public class OffersListUseCase: OffersListUseCaseProtocol {
    
    
    // MARK: - Properties
    private let services: SmilesTouristServiceHandlerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(services: SmilesTouristServiceHandlerProtocol) {
        self.services = services
    }
    
    // MARK: - getBogoOffers
    func getOffers(categoryId: Int?, tag: SectionTypeTag? = .exclusiveDealsBogoOffers, pageNo: Int? = 1) -> AnyPublisher<OffersListUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.getOffers(categoryId: categoryId, tag: tag, pageNo: pageNo)
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
    
    
    func getOffersWithFilters(categoryId: Int?, tag: SectionTypeTag? = .exclusiveDealsBogoOffers, pageNo: Int? = 1, categoryTypeIdsList: [String]?) -> AnyPublisher<State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.getOffersWithFilters(categoryId: categoryId, tag: tag, pageNo: pageNo, categoryTypeIdsList: categoryTypeIdsList)
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


extension OffersListUseCase {
    enum State {
        case success(response: OffersCategoryResponseModel)
        case failure(message: String)
    }
}
