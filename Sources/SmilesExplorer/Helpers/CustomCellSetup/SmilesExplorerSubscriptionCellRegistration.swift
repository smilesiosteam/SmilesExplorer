//
//  File.swift
//  
//
//  Created by Habib Rehman on 18/08/2023.
//

import Foundation
import SmilesUtilities
import UIKit


struct SmilesExplorerSubscriptionCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        
        tableView.registerCellFromNib(SmilesExplorerMembershipCardsTableViewCell.self, withIdentifier: String(describing: SmilesExplorerMembershipCardsTableViewCell.self), bundle: .module)
        
    }
    
}
