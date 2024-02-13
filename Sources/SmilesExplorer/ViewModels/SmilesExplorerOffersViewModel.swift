//
//  File.swift
//  
//
//  Created by Shmeel Ahmed on 01/08/2023.
//


import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesOffers
import SmilesBaseMainRequestManager
import UIKit

class SmilesExplorerOffersViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case fetchSmilesExplorerOffers(page:Int)
    }
    
    enum Output {
        case getSmilesExplorerOffersDidSucceed(response: OffersCategoryResponseModel)
        case getSmilesExplorerOffersDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

}

extension SmilesExplorerOffersViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .fetchSmilesExplorerOffers(let page):
                self?.fetchSmilesExplorerOffersData(page:page)
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func fetchSmilesExplorerOffersData(page:Int) {
        let offersCategoryRequest = OffersCategoryRequestModel(pageNo:page, categoryId: "\(ExplorerConstants.explorerCategoryID)", tag: "TICKETS")
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
                    self?.output.send(.getSmilesExplorerOffersDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.getSmilesExplorerOffersDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
