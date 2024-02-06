//
//  File.swift
//  
//
//  Created by Habib Rehman on 05/02/2024.
//


import Foundation
import UIKit
import Combine
import NetworkingLayer
import SmilesUtilities

public struct SmilesTouristDependance {
    public var categoryId: String

    public init(categoryId: String) {
        self.categoryId = categoryId
    }
}



public enum SmilesTouristConfigrator {
//    
//    public static func getOrderTrackingView(dependance: OrderTrackingDependance,
//                                            navigationDelegate: OrderTrackingNavigationProtocol,
//                                            firebasePublisher: AnyPublisher<LiveTrackingState, Never>
//    ) -> OrderTrackingViewController {
//        let useCase = OrderTrackingUseCase(orderId: dependance.orderId,
//                                           orderNumber: dependance.orderNUmber,
//                                           services: service, timer: TimerManager())
//        let orderConfirmationUseCase = OrderConfirmationUseCase(services: service)
//        let changeTypeUseCase = ChangeTypeUseCase(services: service)
//        let scratchAndWinUseCase = ScratchAndWinUseCase()
//        let useCasePauseOrder = PauseOrderUseCase(services: service)
//        let viewModel = OrderTrackingViewModel(useCase: useCase, confirmUseCase: orderConfirmationUseCase, changeTypeUseCase: changeTypeUseCase, scratchAndWinUseCase: scratchAndWinUseCase, firebasePublisher: firebasePublisher, pauseOrderUseCase: useCasePauseOrder)
//        viewModel.navigationDelegate = navigationDelegate
//        viewModel.orderId = dependance.orderId
//        viewModel.orderNumber = dependance.orderNUmber
//        viewModel.checkForVoucher = dependance.checkForVoucher
//        viewModel.chatbotType = dependance.chatbotType
//        viewModel.personalizationEventSource = dependance.personalizationEventSource
//        let viewController = OrderTrackingViewController.create()
//        viewController.viewModel = viewModel
//        viewController.isCameFromMyOrder = dependance.isCameFromMyOrder
//        return viewController
//    }
    
    
    static var service: SmilesTouristServiceHandler {
        return .init(repository: repository)
    }
    
    static var network: Requestable {
        NetworkingLayerRequestable(requestTimeOut: 60)
    }
    
    static var repository: SmilesTouristServiceable {
        SmilesTouristRepository(networkRequest: network)
    }
    
    

    
}

