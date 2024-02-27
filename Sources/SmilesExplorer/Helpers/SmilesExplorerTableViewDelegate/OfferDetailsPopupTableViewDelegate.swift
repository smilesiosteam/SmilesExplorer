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
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
}
