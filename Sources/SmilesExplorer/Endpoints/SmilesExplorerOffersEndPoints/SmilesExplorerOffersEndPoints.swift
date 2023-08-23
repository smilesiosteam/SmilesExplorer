//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 17/08/2023.
//
import Foundation

public enum SmilesExplorerOffersEndPoints: String, CaseIterable {
    case fetchOffersList
}

extension SmilesExplorerOffersEndPoints{
    var serviceEndPoints: String {
        switch self {
        case .fetchOffersList:
            return "explorer/offers"
        }
    }
}

