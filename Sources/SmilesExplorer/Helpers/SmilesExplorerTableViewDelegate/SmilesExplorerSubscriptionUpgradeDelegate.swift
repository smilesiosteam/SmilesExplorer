//
//  File.swift
//  
//
//  Created by Habib Rehman on 05/09/2023.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesSharedServices
import SmilesOffers
import SmilesStoriesManager

extension SmilesExplorerSubscriptionUpgradeViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: indexPath.section] {
            if sectionData.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue {
                self.onUpgradeBannerButtonClick()
            } else if sectionData.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue {
                SmilesExplorerRouter.shared.pushOffersVC(navVC: self.navigationController!)
            }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: indexPath.section] {
            if sectionData.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue || sectionData.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue {
                return 150
            }else {
                return UITableView.automaticDimension
            }
        }
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
            if sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.topPlaceholder.rawValue && sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue && sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue{
                if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
                    if sectionData.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.offerListing.rawValue  {
                        self.input.send(.getFiltersData(filtersSavedList: self.filtersSavedList, isFilterAllowed: 1, isSortAllowed: 1)) // Get Filters Data
                        let filtersCell = tableView.dequeueReusableCell(withIdentifier: "FiltersTableViewCell") as! FiltersTableViewCell
                        filtersCell.title.text = sectionData.title
                        filtersCell.title.setTextSpacingBy(value: -0.2)
                        filtersCell.subTitle.text = sectionData.subTitle
                        filtersCell.filtersData = self.filtersData
                        filtersCell.backgroundColor = UIColor(hexString: sectionData.backgroundColor ?? "")
                        
                        filtersCell.callBack = { [weak self] filterData in
                            if filterData.tag == RestaurantFiltersType.filters.rawValue {
                                
                                self?.redirectToRestaurantFilters()
                            } else if filterData.tag == RestaurantFiltersType.deliveryTime.rawValue {
                                // Delivery time
//                                self?.redirectToSortingVC()
                            } else {
                                // Remove and saved filters
//                                self?.input.send(.removeAndSaveFilters(filter: filterData))
                            }
                        }
                        
                        if let section = self.smilesExplorerSections?.sectionDetails?[safe: section] {
                            if section.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.offerListing.rawValue {
                                filtersCell.stackViewTopConstraint.constant = 20
                                
                                filtersCell.layer.cornerRadius = 12
                                filtersCell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                            }
                        }
                        filtersCell.backgroundColor = .white
                        self.configureHeaderForShimmer(section: section, headerView: filtersCell)
                        return filtersCell
                    }else{
                        if sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue && sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue{
                            let header = SmilesExplorerHeader()
                            header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""), section: section)
                            header.bgMainView.backgroundColor = .appRevampPurpleMainColor
                            header.backgroundColor = .appRevampPurpleMainColor
                            configureHeaderForShimmer(section: section, headerView: header)
                            return header
                        }
                    }
                }
            }
        }
        
        
        return UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let offersIndex = getSectionIndex(for: .offerListing) {
            if indexPath.section == offersIndex {
                let lastItem = self.bogoOffers.endIndex - 1
                if indexPath.row == lastItem {
                    if bogoOffers.count != (bogooffersListing?.offersCount ?? 0)  {
                        offersPage += 1
                        self.input.send(.getBogoOffers(categoryId: self.categoryId, tag: .exclusiveDealsBogoOffers, pageNo: offersPage))
                    }
                }
            }
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
        
        if let storiesSectionIndex = getSectionIndex(for: .stories), storiesSectionIndex == section {
            if let dataSource = (self.dataSource?.dataSources?[safe: storiesSectionIndex] as? TableViewDataSource<Stories>) {
                showHide(isDummy: dataSource.isDummy)
            }
        }else if let offerListingSectionIndex = getSectionIndex(for: .offerListing), offerListingSectionIndex == section {
            if let dataSource = (self.dataSource?.dataSources?[safe: offerListingSectionIndex] as? TableViewDataSource<OfferDO>) {
                showHide(isDummy: dataSource.isDummy)
            }
        }
        
    }
    
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        var tableViewHeight = tableView.frame.height
//        if topHeaderView.alpha == 0 {
//            tableViewHeight -= 153
//        }
//        guard scrollView.contentSize.height > tableViewHeight else { return }
//        var compact: Bool?
//        if scrollView.contentOffset.y > 90 {
//           compact = true
//        } else if scrollView.contentOffset.y < 0 {
//            compact = false
//        }
//        guard let compact, compact != (topHeaderView.alpha == 0) else { return }
//        if compact {
//            self.setUpNavigationBar()
////            self.setUpNavigationBar(isLightContent: false)
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
//                self.topHeaderView.alpha = 0
//                self.tableViewTopSpaceToHeaderView.priority = .defaultLow
//                self.tableViewTopSpaceToSuperView.priority = .defaultHigh
//                self.tableViewTopSpaceToSuperView.constant = 100
//                self.view.layoutIfNeeded()
//            })
//        } else {
//            self.setUpNavigationBar()
//            UIView.animate(withDuration: 0.3, delay: 0.0, options: .transitionCrossDissolve, animations: {
//                self.topHeaderView.alpha = 1
//                self.tableViewTopSpaceToHeaderView.priority = .defaultHigh
//                self.tableViewTopSpaceToSuperView.priority = .defaultLow
//                
//                self.tableViewTopSpaceToSuperView.constant = 228
//                self.view.layoutIfNeeded()
//            })
//        }
//        
//    }
    
}
