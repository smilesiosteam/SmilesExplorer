//
//  File.swift
//  
//
//  Created by Habib Rehman on 22/08/2023.
//


import Foundation
import SmilesBaseMainRequestManager

public class ExplorerGetExclusiveOfferRequest: SmilesBaseMainRequest {
    
    // MARK: - Model Variables
    
    var categoryId: Int?
    var tag: String?
    var pageNo: Int?
    var subCategoryId: String?
    var subCategoryTypeIdsList: [String]?
    var isGuestUser: Bool?
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
       
        case categoryId
        case tag
        case pageNo
        case subCategoryId
        case subCategoryTypeIdsList
        case isGuestUser
    }
    
    public init(categoryId: Int?, tag: String? = nil, pageNo: Int? = 1,subCategoryId: String? = nil, subCategoryTypeIdsList: [String]? = nil, isGuestUser: Bool? = nil) {
        super.init()
        self.categoryId = categoryId
        self.tag = tag
        self.pageNo = pageNo
        self.subCategoryId = subCategoryId
        self.subCategoryTypeIdsList = subCategoryTypeIdsList
        self.isGuestUser = isGuestUser
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.categoryId, forKey: .categoryId)
        try container.encodeIfPresent(self.tag, forKey: .tag)
        try container.encodeIfPresent(self.pageNo, forKey: .pageNo)
        try container.encodeIfPresent(self.subCategoryId, forKey: .subCategoryId)
        try container.encodeIfPresent(self.subCategoryTypeIdsList, forKey: .subCategoryTypeIdsList)
        try container.encodeIfPresent(self.isGuestUser, forKey: .isGuestUser)
    }
}
