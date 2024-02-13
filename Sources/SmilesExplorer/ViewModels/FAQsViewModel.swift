//
//  File.swift
//  
//
//  Created by Habib Rehman on 12/02/2024.
//

import Foundation
import Combine
import SmilesSharedServices
import SmilesUtilities

final class ExplorerFAQsViewModel {
    
    private var statusSubject = PassthroughSubject<State, Never>()
    var faqsPublisher: AnyPublisher<State, Never> {
        statusSubject.eraseToAnyPublisher()
    }
    private let faqsUseCase: FAQsUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(faqsUseCase: FAQsUseCase) {
        self.faqsUseCase = faqsUseCase
    }
    
    func getFaqs(){
        self.faqsUseCase.getFAQsDetails(faqId: ExplorerConstants.explorerFAQsID, baseUrl: AppCommonMethods.serviceBaseUrl)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .fetchFAQsDidSucceed(response: let response):
                    self.statusSubject.send(.fetchFAQsDidSucceed(response: response))
                case .fetchFAQsDidFail(error: let error):
                    self.statusSubject.send(.fetchFAQsDidFail(error: error.localizedDescription))
                }
            }
            .store(in: &cancellables)
        
    }
}

// MARK: - VIEW MODEL STATE -
extension ExplorerFAQsViewModel {
    
    enum State {
        case fetchFAQsDidSucceed(response: FAQsDetailsResponse)
        case fetchFAQsDidFail(error: String)
    }
    
}
