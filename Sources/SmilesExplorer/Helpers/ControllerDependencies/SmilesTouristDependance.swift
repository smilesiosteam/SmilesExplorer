//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 12/02/2024.
//

import Foundation
import SmilesSharedServices

public struct SmilesTouristDependance {
    public var categoryId: Int
    public var selectedSort: String?
    public var rewardPoint: Int?
    public var rewardPointIcon: String?
    public var personalizationEventSource: String?
    public var platinumLimiReached: Bool?
    public let isGuestUser: Bool
    public var isUserSubscribed: Bool?
    public var subscriptionType: ExplorerPackage?
    public var voucherCode: String?
    public weak var delegate:SmilesExplorerHomeDelegate? = nil
    

    public init(categoryId: Int, isGuestUser: Bool, isUserSubscribed: Bool? = nil, subscriptionType: ExplorerPackage? = nil, voucherCode: String? = nil, delegate:SmilesExplorerHomeDelegate, rewardPoint: Int, rewardPointIcon: String,personalizationEventSource: String?,platinumLimiReached: Bool?) {
        self.platinumLimiReached = platinumLimiReached
        self.personalizationEventSource =  personalizationEventSource
        self.categoryId = categoryId
        self.isGuestUser = isGuestUser
        self.isUserSubscribed = isUserSubscribed
        self.subscriptionType = subscriptionType
        self.voucherCode = voucherCode
        self.delegate = delegate
        self.rewardPointIcon = rewardPointIcon
        self.rewardPoint = rewardPoint
        
    }
}
