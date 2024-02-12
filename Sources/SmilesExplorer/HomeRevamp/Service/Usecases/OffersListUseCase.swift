//
//  File.swift
//  
//
//  Created by Habib Rehman on 05/02/2024.
//

import Foundation
import Combine
import SmilesOffers

protocol OffersListUseCaseProtocol {
    func getOffers(categoryId: Int?, tag: SectionTypeTag?, pageNo: Int?, categoryTypeIdsList: [String]?) -> AnyPublisher<OffersListUseCase.State, Never>
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
    func getOffers(categoryId: Int?, tag: SectionTypeTag?, pageNo: Int?, categoryTypeIdsList: [String]? = nil) -> AnyPublisher<OffersListUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            self.services.getOffers(categoryId: categoryId, tag: tag, pageNo: pageNo, categoryTypeIdsList: categoryTypeIdsList)
                .sink { completion in
                    if case .failure(let error) = completion {
                        promise(.success(.offersDidFail(error: error.localizedDescription)))
                    }
                } receiveValue: { response in
                    promise(.success(.fetchOffersDidSucceed(response: response)))
                }
                .store(in: &cancellables)
        }
        .eraseToAnyPublisher()
        
    }
  
}
 
 
extension OffersListUseCase {
    enum State {
        case fetchOffersDidSucceed(response: OffersCategoryResponseModel)
        case offersDidFail(error: String)
    }
}
