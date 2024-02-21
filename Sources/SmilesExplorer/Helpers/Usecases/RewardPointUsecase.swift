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

protocol RewardPointUseCaseProtocol {
    func getRewardPoints() -> Future<RewardPointUseCase.State, Never>
}

class RewardPointUseCase: RewardPointUseCaseProtocol {
    
    public var rewardPointsUseCaseInput: PassthroughSubject<RewardPointsViewModel.Input, Never> = .init()
    private let rewardPointsViewModel = RewardPointsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func getRewardPoints() -> Future<RewardPointUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            rewardPointsUseCaseInput = PassthroughSubject<RewardPointsViewModel.Input, Never>()
            let output = rewardPointsViewModel.transform(input: rewardPointsUseCaseInput.eraseToAnyPublisher())
            self.rewardPointsUseCaseInput.send(.getRewardPoints(baseUrl: AppCommonMethods.serviceBaseUrl))
            output.sink { event in
                switch event {
                case .fetchRewardPointsDidSucceed(response: let response, shouldLogout: let logout):
                    debugPrint(response)
                    promise(.success(.fetchRewardPointsDidSucceed(response: response, shouldLogout: logout ?? false)))
                case .fetchRewardPointsDidFail(error: let error):
                    print(error.localizedDescription)
                    promise(.success(.fetchRewardPointsDidFail(error: error)))
                }
            }.store(in: &cancellables)
        }
        
    }
    
}
extension RewardPointUseCase {
    enum State {
        case fetchRewardPointsDidSucceed(response: RewardPointsResponseModel,shouldLogout:Bool)
        case fetchRewardPointsDidFail(error: Error)
    }
}
