//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/09/2023.
//

import UIKit
import SmilesUtilities
import SmilesStoriesManager
import SmilesOffers

struct SmilesExplorerSubscriptionUpgradeCellRegistration: CellRegisterable {
    
    func register(for tableView: UITableView) {
        tableView.registerCellFromNib(StoriesTableViewCell.self, withIdentifier: String(describing: StoriesTableViewCell.self))
        
        tableView.registerCellFromNib(RestaurantsRevampTableViewCell.self, bundle: RestaurantsRevampTableViewCell.module)
    }
}
