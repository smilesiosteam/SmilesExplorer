//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 08/02/2024.
//

import UIKit

extension ExplorerOffersListingViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
