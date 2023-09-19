//
//  File.swift
//  
//
//  Created by Habib Rehman on 22/08/2023.
//


import Foundation
import Combine
import NetworkingLayer
import SmilesOffers
import SmilesUtilities

public class SmilesExplorerGetOffersViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case getExclusiveOffersList(categoryId: Int?, tag: String?,page:Int = 1)
        
        case getTickets(categoryId: Int?, tag: String?,page:Int = 1)
        
        case getBogo(categoryId: Int?, tag: String?,page:Int = 1)
        
    }
    
    enum Output {
        case fetchExclusiveOffersDidSucceed(response: ExplorerOfferResponse)
        case fetchExclusiveOffersDidFail(error: Error)
        
        case fetchTicketsDidSucceed(response: ExplorerOfferResponse)
        case fetchTicketDidFail(error: Error)
        
        case fetchBogoDidSucceed(response: ExplorerOfferResponse)
        case fetchBogoDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
}

extension SmilesExplorerGetOffersViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .getExclusiveOffersList(let categoryId,let tag,_):
                self?.getExclusiveOffersList(categoryId: categoryId ?? 0, tag: tag ?? "")
                
            case .getTickets(categoryId: let categoryId, tag: let tag, _):
                self?.getExclusiveOffersList(categoryId: categoryId ?? 0, tag: tag ?? "")
            case .getBogo(categoryId: let categoryId, tag: let tag, page: _):
                self?.getExclusiveOffersList(categoryId: categoryId ?? 0, tag: tag ?? "")
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func getExclusiveOffersList(categoryId: Int, tag: String, page: Int = 1) {
        let exclusiveOffersRequest = ExplorerGetExclusiveOfferRequest(categoryId: categoryId, tag: tag)
        
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
                
                if let section = SmilesExplorerSectionIdentifier(rawValue: tag){
                    switch section {
                    case .exclusiveDeals:
                        self?.output.send(.fetchExclusiveOffersDidSucceed(response: response))
                    case .tickets:
                        self?.output.send(.fetchTicketsDidSucceed(response: response))
                        break
                    case .bogoOffers:
                        self?.output.send(.fetchBogoDidSucceed(response: response))
                        break
                    default:
                        break
                    }
                }
            }
        .store(in: &cancellables)
    }
}
