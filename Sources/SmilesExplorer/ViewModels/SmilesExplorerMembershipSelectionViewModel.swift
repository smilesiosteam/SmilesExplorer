//
//  File.swift
//  
//
//  Created by Habib Rehman on 17/08/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities

class SmilesExplorerMembershipSelectionViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    public enum Input {
        case getSubscriptionInfo
    }
    
    public enum Output {
        case fetchSubscriptionInfoDidSucceed(response: SmilesExplorerSubscriptionInfoResponse)
        case fetchSubscriptionInfoDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
}

// MARK: - INPUT. View event methods
extension SmilesExplorerMembershipSelectionViewModel {
    
    public func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getSubscriptionInfo:
                self?.getSubscriptionInfo()
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    // Get All Sections
    private func getSubscriptionInfo() {
        
        let request = SmilesExplorerSubscriptionInfoRequest()
        let service = SmilesExplorerSubscriptionInfoRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl, endpoint: .subscriptionInfo)
        service.getSubscriptionInfoService(request: request)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchSubscriptionInfoDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                self?.output.send(.fetchSubscriptionInfoDidSucceed(response: response))
            }
        .store(in: &cancellables)
        
    }
    
}
