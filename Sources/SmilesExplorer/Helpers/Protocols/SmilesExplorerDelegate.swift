//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//

import Foundation

public protocol SmilesExplorerDelegate: AnyObject {
    
    func proceedToPayment(params: SmilesExplorerPaymentParams)
    func handleLinkRedirection(redirectionUrl: String)
    
}
