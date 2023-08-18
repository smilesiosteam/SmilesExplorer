//
//  File.swift
//  
//
//  Created by Habib Rehman on 18/08/2023.
//

import Foundation
import UIKit


extension SmilesExplorerMembershipCardsViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        

        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MembershipTableViewFooterview") as! MembershipTableViewFooterview
//                
//                // Customize or set actions for the button here
//                footerView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//
//                return footerView
//        
//        footerView.button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
//
//            return footerView
//        }

        @objc func buttonTapped() {
            // Handle button tap action here
        }
    
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    

    

    
}
