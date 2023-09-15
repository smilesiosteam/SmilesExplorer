//
//  File.swift
//  
//
//  Created by Habib Rehman on 14/09/2023.
//

import Foundation
import UIKit
import SmilesUtilities

struct SmilesExplorerFiltersCellRegistration: CellRegisterable {
    
    
    func register(for tableView: UITableView) {
        tableView.registerCellFromNib(SmilesExplorerFilterTVC.self, withIdentifier: "SmilesExplorerFilterTVC", bundle: .module)

    tableView.registerCellFromNib(SmilesExplorerFilterSelectionTVC.self, withIdentifier: "SmilesExplorerFilterSelectionTVC", bundle: .module)
        
    }
    
}


