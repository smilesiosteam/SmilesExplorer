//
//  File.swift
//  
//
//  Created by Habib Rehman on 12/02/2024.
//


import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesSharedServices

protocol FAQsUseCaseProtocol {
    func getFAQsDetails(faqId: Int, baseUrl: String) -> Future<FAQsUseCase.State, Never>
}

class FAQsUseCase: FAQsUseCaseProtocol {

    public var fAQsUseCaseInput: PassthroughSubject<FAQsViewModel.Input, Never> = .init()
    private let fAQsViewModel = FAQsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func getFAQsDetails(faqId: Int, baseUrl: String) -> Future<FAQsUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            fAQsUseCaseInput = PassthroughSubject<FAQsViewModel.Input, Never>()
        let output = fAQsViewModel.transform(input: fAQsUseCaseInput.eraseToAnyPublisher())
            self.fAQsUseCaseInput.send(.getFAQsDetails(faqId: faqId, baseUrl: baseUrl))
            output.sink { event in
                    switch event {
                    case .fetchFAQsDidSucceed(response: let response):
                        debugPrint(response)
                        promise(.success(.fetchFAQsDidSucceed(response: response)))
                    case .fetchFAQsDidFail(error: let error):
                        print(error.localizedDescription)
                        promise(.success(.fetchFAQsDidFail(error: error)))
                    }
                }.store(in: &cancellables)
        }
       
    }
    
}
extension FAQsUseCase {
    enum State {
        case fetchFAQsDidSucceed(response: FAQsDetailsResponse)
        case fetchFAQsDidFail(error: Error)
    }
}
