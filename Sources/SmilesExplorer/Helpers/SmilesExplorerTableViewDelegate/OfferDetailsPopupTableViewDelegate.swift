//
//  File.swift
//  
//
//  Created by Habib Rehman on 15/02/2024.
//

import UIKit
import Foundation

extension OfferDetailsPopupVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    //MARK: - HeaderView Setup -
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = OffersPopupHeaderView(reuseIdentifier: "OffersPopupHeaderView")
            headerView.setTitle("At the Top")
            return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }else{
            return 0
        }
    }
    
}
