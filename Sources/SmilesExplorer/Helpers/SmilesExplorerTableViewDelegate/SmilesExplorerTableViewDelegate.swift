//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/08/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers

extension SmilesExplorerHomeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.smilesExplorerSections?.sectionDetails?[safe: indexPath.section]?.sectionIdentifier {
        case SmilesExplorerSectionIdentifier.footer.rawValue:
            return 540
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
            if sectionData.sectionIdentifier != SmilesExplorerSectionIdentifier.topPlaceholder.rawValue && sectionData.sectionIdentifier != SmilesExplorerSectionIdentifier.footer.rawValue {
                let header = SmilesExplorerHeader()
                header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""), section: section)
                configureHeaderForShimmer(section: section, headerView: header)
                return header
            }
        }
        
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch self.smilesExplorerSections?.sectionDetails?[safe: section]?.sectionIdentifier {
        case SmilesExplorerSectionIdentifier.footer.rawValue:
            return 0.0
        default:
            return UITableView.automaticDimension
        }
    }
    
    func configureHeaderForShimmer(section: Int, headerView: UIView) {
        
        func showHide(isDummy: Bool) {
            if isDummy {
                headerView.enableSkeleton()
                headerView.showAnimatedGradientSkeleton()
            } else {
                headerView.hideSkeleton()
            }
        }
        
        if let ticketsSectionIndex = getSectionIndex(for: .tickets), ticketsSectionIndex == section {
            if let dataSource = (self.dataSource?.dataSources?[safe: ticketsSectionIndex] as? TableViewDataSource<OfferDO>) {
                showHide(isDummy: dataSource.isDummy)
            }
        }
        
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        var tableViewHeight = contentTableView.frame.height
//        if headerView.alpha == 0 {
//            tableViewHeight -= 153
//        }
//        guard scrollView.contentSize.height > tableViewHeight else { return }
//        var compact: Bool?
//        if scrollView.contentOffset.y > 90 {
//           compact = true
//        } else if scrollView.contentOffset.y < 0 {
//            compact = false
//        }
//        guard let compact, compact != (headerView.alpha == 0) else { return }
//        if compact {
//            self.setUpNavigationBar(isLightContent: false)
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
//                self.headerView.alpha = 0
//                self.tableViewTopSpaceToHeaderView.priority = .defaultLow
//                self.tableViewTopSpaceToSuperView.priority = .defaultHigh
//                self.view.layoutIfNeeded()
//            })
//        } else {
//            self.setUpNavigationBar()
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
//                self.headerView.alpha = 1
//                self.tableViewTopSpaceToHeaderView.priority = .defaultHigh
//                self.tableViewTopSpaceToSuperView.priority = .defaultLow
//                self.view.layoutIfNeeded()
//            })
//        }
        
    }
    
}
