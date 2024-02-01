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
    var sortingType:String?
    var categoryTypeIdsList:[String]?
    
    
    // MARK: - Model Keys
    
    enum CodingKeys: CodingKey {
       
        case categoryId
        case tag
        case pageNo
        case sortingType
        case categoryTypeIdsList
        
    }
    
    public init(categoryId: Int?, tag: String? = nil, pageNo: Int?, sortingType:String? = nil, categoryTypeIdsList:[String]? = nil) {
        super.init()
        self.categoryId = categoryId
        self.tag = tag
        self.pageNo = pageNo
        self.sortingType = sortingType
        self.categoryTypeIdsList = categoryTypeIdsList
        
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
        try container.encodeIfPresent(self.sortingType, forKey: .sortingType)
        try container.encodeIfPresent(self.categoryTypeIdsList, forKey: .categoryTypeIdsList)
    }
}
