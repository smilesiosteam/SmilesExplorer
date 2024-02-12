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

final class FAQsHomeViewModel {
    
    public enum Output {
        case fetchFAQsDidSucceed(response: FAQsDetailsResponse)
        case fetchFAQsDidFail(error: Error)
        
    }
    
    private var faqsUseCaseOutput: PassthroughSubject<FAQsViewModel.Output, Never> = .init()
    
    private let faqsUseCase: FAQsUseCaseProtocol
    var output: PassthroughSubject<Output, Never> = .init()
    var cancellables = Set<AnyCancellable>()
    
    
    init(faqsUseCase: FAQsUseCase) {
        self.faqsUseCase = faqsUseCase
    }
    
    func getFaqs(){
        self.faqsUseCase.getFAQsDetails(faqId: 11, baseUrl: AppCommonMethods.serviceBaseUrl)
            .sink { [weak self] state in
            guard self != nil else {
                return
            }
            switch state {
            case .fetchFAQsDidSucceed(response: let response):
                print(response)
                self?.output.send(.fetchFAQsDidSucceed(response: response))
            case .fetchFAQsDidFail(error: let error):
                self?.output.send(.fetchFAQsDidFail(error: error))
                debugPrint(error.localizedDescription)
            }
        }
        .store(in: &cancellables)

    }
}
