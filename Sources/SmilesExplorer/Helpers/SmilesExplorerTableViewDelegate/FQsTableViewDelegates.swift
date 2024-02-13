//
//  File.swift
//
//
//  Created by Habib Rehman on 12/02/2024.
//

import UIKit
import Foundation
import SmilesSharedServices
import SmilesUtilities

extension FAQsViewController: UITableViewDelegate{
    //MARK: - DidSelect Method
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let faqDetail = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<FaqsDetail>)?.models?[safe: indexPath.row] as? FaqsDetail)
        faqDetail?.isHidden = !(faqDetail?.isHidden ?? true)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) == 0 {
            return 0
        }
        
        return UITableView.automaticDimension
    }
}

