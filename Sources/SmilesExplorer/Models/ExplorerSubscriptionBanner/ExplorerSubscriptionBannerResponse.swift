//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 07/02/2024.
//

import Foundation
import NetworkingLayer

class ExplorerSubscriptionBannerResponse: BaseMainResponse {
    
    let footer: HomeFooter?

    enum CodingKeys: String, CodingKey {
        case themeResources
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        footer = try values.decodeIfPresent(HomeFooter.self, forKey: .themeResources)
        try super.init(from: decoder)
    }

}

// MARK: - ThemeResources
class HomeFooter: Codable {
    let explorerSubBannerBgImage, explorerSubBannerBgColor, explorerSubBannerPrice, explorerSubBannerDescription, explorerSubBannerColorDirection: String?
}
