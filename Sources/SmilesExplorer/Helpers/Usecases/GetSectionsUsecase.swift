//
//  File.swift
//
//
//  Created by Habib Rehman on 09/02/2024.
//

import Foundation
import Combine
import NetworkingLayer
import SmilesUtilities
import SmilesSharedServices

protocol SectionsUseCaseProtocol {
    
    func getSections(categoryID: Int?, type: String?, explorerPackageType: ExplorerPackage?, freeTicketAvailed: Bool?, platinumLimitReached: Bool?) -> Future<SectionsUseCase.State, Never>
}

class SectionsUseCase: SectionsUseCaseProtocol {
    
    public var sectionsUseCaseInput: PassthroughSubject<SectionsViewModel.Input, Never> = .init()
    private let sectionsViewModel = SectionsViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func getSections(categoryID: Int?, type: String? = nil, explorerPackageType: ExplorerPackage? = nil, freeTicketAvailed: Bool? = nil, platinumLimitReached: Bool? = nil) -> Future<SectionsUseCase.State, Never> {
        return Future<State, Never> { [weak self] promise in
            guard let self else {
                return
            }
            sectionsUseCaseInput = PassthroughSubject<SectionsViewModel.Input, Never>()
            let output = sectionsViewModel.transform(input: sectionsUseCaseInput.eraseToAnyPublisher())
            self.sectionsUseCaseInput.send(.getSections(categoryID: categoryID, baseUrl: AppCommonMethods.serviceBaseUrl, isGuestUser: AppCommonMethods.isGuestUser, type: type,explorerPackageType: explorerPackageType,freeTicketAvailed: freeTicketAvailed,platinumLimitReached: platinumLimitReached))
            output.sink { event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    debugPrint(sectionsResponse)
                    promise(.success(.sectionsDidSucceed(response: sectionsResponse)))
                case .fetchSectionsDidFail(let error):
                    print(error.localizedDescription)
                    promise(.success(.sectionsDidFail(error: error)))
                }
            }.store(in: &cancellables)
        }
        
    }
    
}
extension SectionsUseCase {
    enum State {
        case sectionsDidSucceed(response: GetSectionsResponseModel)
        case sectionsDidFail(error: Error)
    }
}

