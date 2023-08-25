//
//  File.swift
//  
//
//  Created by Ghullam  Abbas on 24/08/2023.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesOffers
import SmilesBaseMainRequestManager
import UIKit

class SmilesExplorerPickTicketViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case fetchSmilesExplorerTickets(page:Int)
    }
    
    enum Output {
        case getSmilesExplorerTickesDidSucceed(response: OffersCategoryResponseModel)
        case getSmilesExplorerTickesDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

}

extension SmilesExplorerPickTicketViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .fetchSmilesExplorerTickets(let page):
                self?.fetchSmilesExplorerTicketData(page:page)
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func fetchSmilesExplorerTicketData(page:Int) {
        
        let offersCategoryRequest = OffersCategoryRequestModel(pageNo:page, categoryId: "", tag: "TICKETS")
        let service = SmilesExplorerOffersRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .fetchOffersList
        )
        
        service.smilesExplorerOffersService(request: offersCategoryRequest)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.getSmilesExplorerTickesDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.getSmilesExplorerTickesDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
