//
//  File.swift
//  
//
//  Created by Shmeel Ahmed on 11/09/2023.
//
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesOffers
import SmilesBaseMainRequestManager
import UIKit

class SmilesExplorerGiftCardValidationViewModel: NSObject {
    
    // MARK: - INPUT. View event methods
    enum Input {
        case validateGift(giftCode:String)
    }
    
    enum Output {
        case validateGiftDidSucceed(response: ValidateGiftCardResponseModel)
        case validateGiftDidFail(error: Error)
    }
    
    // MARK: -- Variables
    private var output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

}

extension SmilesExplorerGiftCardValidationViewModel {
    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        output = PassthroughSubject<Output, Never>()
        input.sink { [weak self] event in
            switch event {
            case .validateGift(let giftCode):
                self?.validateGiftCode(giftCode: giftCode)
                
            }
        }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    func validateGiftCode(giftCode:String) {
        
        let request = ValidateGiftCardRequestModel(giftCode:giftCode)
        let service = SmilesExplorerOffersRepository(
            networkRequest: NetworkingLayerRequestable(requestTimeOut: 60),
            baseUrl: AppCommonMethods.serviceBaseUrl,
            endPoint: .validateGift
        )
        
        service.smilesExplorerValidateGiftService(request: request)
            .sink { [weak self] completion in
                debugPrint(completion)
                switch completion {
                case .failure(let error):
                    self?.output.send(.validateGiftDidFail(error: error))
                case .finished:
                    debugPrint("nothing much to do here")
                }
            } receiveValue: { [weak self] response in
                debugPrint("got my response here \(response)")
                self?.output.send(.validateGiftDidSucceed(response: response))
            }
        .store(in: &cancellables)
    }
}
