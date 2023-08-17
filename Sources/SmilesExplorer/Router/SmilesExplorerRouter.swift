//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 14/08/2023.
//


import SmilesSharedServices
import SmilesUtilities
import UIKit

@objcMembers
public final class SmilesExplorerRouter: NSObject {
    
    public static let shared = SmilesExplorerRouter()
    
    private override init() {}
    
    public func pushSmilesExplorerMembershipSuccessVC(navVC: UINavigationController?, model: SmilesExplorerMembershipResponseModel?,sourceScreen: SourceScreen = .success) {
        
        let smilesExplorerMembershipSuccess = SmilesExplorerMembershipSuccessViewController(model: model,sourceScreen: sourceScreen)
        navVC?.pushViewController(smilesExplorerMembershipSuccess, animated: true)
        
    }
    
    
}
