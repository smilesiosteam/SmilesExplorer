//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import Foundation
public enum SmilesExplorerHomeNavigationType {
    case payment, withTextPromo, withQRPromo
}

public protocol SmilesExplorerHomeDelegate {
    
    func proceedToPayment(params: SmilesExplorerPaymentParams, navigationType:SmilesExplorerHomeNavigationType)

    func handleDeepLinkRedirection(redirectionUrl: String)
}
