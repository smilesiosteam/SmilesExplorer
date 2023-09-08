//
//  File.swift
//  
//
//  Created by Habib Rehman on 05/09/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesOffers
import SmilesUtilities

class SmilesExplorerGetOffersStoriesViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case getExclusiveOffersList(categoryId: Int?, tag: String?, pageNo: Int = 1)
    }
    
    enum Output {
        case fetchExclusiveOffersDidSucceed(response: ExplorerOfferResponse)
        case fetchExclusiveOffersDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension SmilesExplorerGetOffersStoriesViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getExclusiveOffersList(let categoryId, let tag, let pageNo):
                self?.getExclusiveOffersList(categoryId: categoryId ?? 0, tag: tag ?? "", pageNo: pageNo)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getExclusiveOffersList(categoryId: Int, tag: String, pageNo: Int = 1) {
        let exclusiveOffersRequest = ExplorerGetExclusiveOfferRequest(categoryId: categoryId, tag: tag, pageNo: pageNo)
        
        let service = SmilesExplorerGetExclusiveOfferRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseUrl: AppCommonMethods.serviceBaseUrl,
            endpoint: .getExclusiveOffer
        )
        
        service.getExclusiveOffers(request: exclusiveOffersRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchExclusiveOffersDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                
                self?.output.send(.fetchExclusiveOffersDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
