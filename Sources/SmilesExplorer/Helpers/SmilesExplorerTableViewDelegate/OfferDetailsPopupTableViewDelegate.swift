//
//  File.swift
//  
//
//  Created by Habib Rehman on 15/02/2024.
//

import UIKit
import Foundation
import SmilesUtilities
import SmilesOffers


extension OfferDetailsPopupVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    //MARK: - HeaderView Setup -
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return nil
        }
        if let dataSource = self.response {
            let headerView = OffersPopupHeaderView(reuseIdentifier: "OffersPopupHeaderView")
            headerView.setTitle(dataSource.offerTitle ?? "")
            configureHeaderForShimmer(section: section, headerView: headerView)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return 0
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
            return UITableView.automaticDimension
    }
    
    
}


extension OfferDetailsPopupVC {
    func configureHeaderForShimmer(section: Int, headerView: UIView) {
        guard let dataSource = self.dataSource?.dataSources?[section] as? TableViewDataSource<String> else {
            return
        }
        if dataSource.isDummy {
            headerView.enableSkeleton()
            headerView.showAnimatedGradientSkeleton()
        } else {
            headerView.hideSkeleton()
        }
    }

}
