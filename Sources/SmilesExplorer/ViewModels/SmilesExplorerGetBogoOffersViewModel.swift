//
//  SmilesExplorerGetBogoOffersViewModel.swift
//  
//
//  Created by Habib Rehman on 06/09/2023.
//

import Foundation



import Foundation
import Combine
import NetworkingLayer
import SmilesOffers
import SmilesUtilities

class SmilesExplorerGetBogoOffersViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case getBogoOffers(categoryId: Int?, tag: String?, pageNo: Int = 1)
    }
    
    enum Output {
       
        case fetchBogoOffersDidSucceed(response: OffersCategoryResponseModel)
        case fetchBogoOffersDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension SmilesExplorerGetBogoOffersViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getBogoOffers(let categoryId, let tag, let pageNo):
                self?.getBogoOffers(categoryId: categoryId ?? 0, tag: tag ?? "", pageNo: pageNo)
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getBogoOffers(categoryId: Int, tag: String, pageNo: Int = 1) {
        let exclusiveOffersRequest = ExplorerGetExclusiveOfferRequest(categoryId: categoryId, tag: tag, pageNo: pageNo)
        
        let service = SmilesExplorerGetExclusiveOfferRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60), baseUrl: AppCommonMethods.serviceBaseUrl,
            endpoint: .getExclusiveOffer
        )
        
        service.getBogoOffers(request: exclusiveOffersRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.fetchBogoOffersDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.fetchBogoOffersDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
