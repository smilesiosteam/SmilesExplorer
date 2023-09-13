//
//  ValidateGiftCardRequestModel.swift
//  
//
//  Created by Shmeel Ahmed on 11/09/2023.
//

import Foundation
import SmilesUtilities
import SmilesBaseMainRequestManager

class ValidateGiftCardRequestModel: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
    let giftCode: String
    
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
        case giftCode
        
    }
    
    public init(giftCode: String) {
        self.giftCode = giftCode
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.giftCode, forKey: .giftCode)
    }
}
