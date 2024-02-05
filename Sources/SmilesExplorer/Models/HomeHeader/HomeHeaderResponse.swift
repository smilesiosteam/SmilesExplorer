//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 05/02/2024.
//

import Foundation
import SmilesUtilities
import NetworkingLayer

final class HomeHeaderResponse: BaseMainResponse {
    
    var headerImage: String?
    var headerTitle: String?
    
    init(headerImage: String, headerTitle: String) {
        super.init()
        self.headerImage = headerImage
        self.headerTitle = headerTitle
    }
    
    enum CodingKeys: String, CodingKey {
        case headerImage, headerTitle
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        headerImage = try values.decodeIfPresent(String.self, forKey: .headerImage)
        headerTitle = try values.decodeIfPresent(String.self, forKey: .headerTitle)
        try super.init(from: decoder)
    }
    
}
