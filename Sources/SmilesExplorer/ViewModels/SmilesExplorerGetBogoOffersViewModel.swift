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

public class SmilesExplorerGetBogoOffersViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
  public  enum Input {
        case getBogoOffers(categoryId: Int?, tag: String?, pageNo: Int,categoryTypeIdsList: [String])
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
            case .getBogoOffers(let categoryId, let tag, let pageNo, let sortingIdsList):
                self?.getBogoOffers(categoryId: categoryId ?? 0, tag: tag ?? "", pageNo: pageNo , categoryTypeIdsList: sortingIdsList )
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getBogoOffers(categoryId: Int, tag: String, pageNo: Int, categoryTypeIdsList: [String]) {
        let exclusiveOffersRequest = ExplorerGetExclusiveOfferRequest(categoryId: categoryId, tag: tag, pageNo: pageNo, categoryTypeIdsList: categoryTypeIdsList)
        
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
