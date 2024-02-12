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

protocol WishListUseCaseProtocol {
    func updateOfferWishlistStatus(operation: Int, offerId: String, baseUrl: String) -> Future<WishListUseCase.State, Never>
}

class WishListUseCase: WishListUseCaseProtocol {
    
    
    public var wishListUseCaseInput: PassthroughSubject<WishListViewModel.Input, Never> = .init()
    private let wishListViewModel = WishListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func updateOfferWishlistStatus(operation: Int, offerId: String, baseUrl: String) -> Future<WishListUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            wishListUseCaseInput = PassthroughSubject<WishListViewModel.Input, Never>()
            let output = wishListViewModel.transform(input: wishListUseCaseInput.eraseToAnyPublisher())
            self.wishListUseCaseInput.send(.updateOfferWishlistStatus(operation: operation, offerId: offerId, baseUrl: baseUrl))
            output.sink { event in
                switch event {
                case .updateWishlistStatusDidSucceed(response: let response):
                    debugPrint(response)
                    promise(.success(.updateWishlistStatusDidSucceed(response: response)))
                case .updateWishlistDidFail(error: let error):
                    print(error.localizedDescription)
                    promise(.success(.updateWishlistDidFail(error: error)))
                }
            }.store(in: &cancellables)
        }
        
    }
    
}
extension WishListUseCase {
    enum State {
        case updateWishlistStatusDidSucceed(response: WishListResponseModel)
        case updateWishlistDidFail(error: Error)
    }
}



