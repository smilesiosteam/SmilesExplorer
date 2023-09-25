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
        
        if let secID = SmilesExplorerSubscriptionUpgradeSectionIdentifier(rawValue: self.smilesExplorerSections?.sectionDetails?[safe: indexPath.section]?.sectionIdentifier ?? ""){
            switch secID {
            case .freetickets:
                SmilesExplorerRouter.shared.pushOffersVC(navVC: self.navigationController!,delegate: self.delegate!)
                break
            case .upgradeBanner:
                self.onUpgradeBannerButtonClick()
            case .stories:
                break
            case .offerListing:
                if let dataSource = ((self.dataSource?.dataSources?[safe: indexPath.section] as? TableViewDataSource<OfferDO>)) {
                    if !dataSource.isDummy {
                        let offer = dataSource.models?[safe: indexPath.row] as? OfferDO
                        self.delegate?.proceedToOfferDetails(offer: offer)
                    }
                }
                break
            case .topPlaceholder:
                break
            }
            
        }
        
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch self.smilesExplorerSections?.sectionDetails?[safe: indexPath.section]?.sectionIdentifier {
        case SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue:
            return 134
        case SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue:
            return 190
        case SmilesExplorerSubscriptionUpgradeSectionIdentifier.stories.rawValue:
            return UITableView.automaticDimension
            
        case SmilesExplorerSubscriptionUpgradeSectionIdentifier.offerListing.rawValue:
             return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
            if sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.topPlaceholder.rawValue && sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue && sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue{
                if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
                    
                    if (sectionData.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.offerListing.rawValue) && (sectionData.isFilterAllowed != 0 || sectionData.isSortAllowed != 0) {
                        self.input.send(.getFiltersData(filtersSavedList: self.filtersSavedList, isFilterAllowed: sectionData.isFilterAllowed, isSortAllowed: sectionData.isSortAllowed)) // Get Filters Data
                        let filtersCell = tableView.dequeueReusableCell(withIdentifier: "FiltersTableViewCell") as! FiltersTableViewCell
                        filtersCell.title.text = sectionData.title
                        filtersCell.title.setTextSpacingBy(value: -0.2)
                        filtersCell.subTitle.text = sectionData.subTitle
                        filtersCell.filtersData = self.filtersData
                        filtersCell.backgroundColor = UIColor(hexString: sectionData.backgroundColor ?? "")
                        
                        filtersCell.callBack = { [weak self] filterData in
                            if filterData.tag == RestaurantFiltersType.filters.rawValue {
                                //self?.redirectToOffersFilters()
                                self?.redirectToFilters()
                            } else if filterData.tag == RestaurantFiltersType.deliveryTime.rawValue {
                                // Delivery time
                                // self?.redirectToSortingVC()
                            } else {
                                // Remove and saved filters
                                self?.input.send(.removeAndSaveFilters(filter: filterData))
                            }
                        }
                        
                        if let section = self.smilesExplorerSections?.sectionDetails?[safe: section] {
                            if section.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.offerListing.rawValue {
                                filtersCell.stackViewTopConstraint.constant = 20
                                
                                filtersCell.parentView.layer.cornerRadius = 24
                                filtersCell.parentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                                filtersCell.parentView.backgroundColor = .white
                            }
                        }
                        filtersCell.backgroundColor = UIColor(red: 245, green: 247, blue: 249)
                        self.configureHeaderForShimmer(section: section, headerView: filtersCell)
                        return filtersCell
                    }else{
                        if sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue && sectionData.sectionIdentifier != SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue{
                            let header = SmilesExplorerHeader()
                            header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""), section: section, isPostSub: true)
                            
                            
                            switch self.smilesExplorerSections?.sectionDetails?[safe: section]?.sectionIdentifier {
                            case SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue:
                                header.bgMainView.backgroundColor = .appRevampPurpleMainColor
                                header.backgroundColor = .appRevampPurpleMainColor
                               
                            case SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue:
                                header.bgMainView.backgroundColor = .appRevampPurpleMainColor
                                header.backgroundColor = .appRevampPurpleMainColor
                                
                            case SmilesExplorerSubscriptionUpgradeSectionIdentifier.stories.rawValue:
                                if let _ = self.smilesExplorerSections?.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.freetickets.rawValue || $0.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.upgradeBanner.rawValue}) {
                                    header.mainView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
                                    header.bgMainView.backgroundColor = .appRevampPurpleMainColor
                                    header.backgroundColor = .appRevampPurpleMainColor
                                }else{
                                    header.mainView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
                                    header.bgMainView.backgroundColor = .white
                                    header.backgroundColor = .white
                                }
                                
                                header.mainView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
                                
                            case SmilesExplorerSubscriptionUpgradeSectionIdentifier.offerListing.rawValue:
                                header.bgMainView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
                                header.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
                                header.mainView.backgroundColor = .white
                                header.mainView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
                                 
                            default:
                                header.mainView.backgroundColor = .white
                                
                            }
                            
                            
                            configureHeaderForShimmer(section: section, headerView: header)
                            return header
                        }
                        
                        
                        
                    }
                }
            }
        }
        
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            return CGFloat.leastNormalMagnitude
        }
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
        
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
            switch SmilesExplorerSubscriptionUpgradeSectionIdentifier(rawValue: sectionData.sectionIdentifier ?? "") {
            case .stories:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<ExplorerOfferResponse>) {
                    showHide(isDummy: dataSource.isDummy)
                }
            case .offerListing:
                
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<OfferDO>) {
                    showHide(isDummy: dataSource.isDummy)
                }
           
            
            default:
                break
            }
        }
        
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        adjustTopHeader(scrollView)
        //        if let indexPath = tableView.indexPath(for: tableView.visibleCells.first ?? UITableViewCell()) {
        //            let backgroundColor = self.categoryDetailsSections?.sectionDetails?[safe: indexPath.section]?.backgroundColor
        //            if let parentViewController = self.parent as? CategoryContainerViewController {
        //                if !parentViewController.shouldAddBillsController {
        //                    parentViewController.topHeaderView.setBackgroundColorForCurveView(color: UIColor(hexString: backgroundColor.asStringOrEmpty()))
        //                } else {
        //                    parentViewController.topHeaderView.setBackgroundColorForTabsCurveView(color: UIColor(hexString: backgroundColor.asStringOrEmpty()))
        //                }
        //            }
        //        }
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
