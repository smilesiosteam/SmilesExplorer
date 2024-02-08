//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 08/02/2024.
//

import Foundation
import SmilesUtilities
import UIKit

struct ExplorerOffersListingCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        tableView.registerCellFromNib(OffersListingTableViewCell.self, withIdentifier: "OffersListingTableViewCell", bundle: .module)
    }
    
}
