//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 03/07/2023.
//

import SmilesBaseMainRequestManager

class SmilesExplorerSubscriptionInfoRequest: SmilesBaseMainRequest {
    var packageType: String?
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
        case packageType
    }
    
    public init(packageType: String? = nil) {
        super.init()
        self.packageType = packageType
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.packageType, forKey: .packageType)
    }
    
}
