//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import Foundation
public protocol SmilesExplorerHomeDelegate {
    
    func proceedToPayment(params: SmilesExplorerPaymentParams)

    func handleDeepLinkRedirection(redirectionUrl: String)
}
