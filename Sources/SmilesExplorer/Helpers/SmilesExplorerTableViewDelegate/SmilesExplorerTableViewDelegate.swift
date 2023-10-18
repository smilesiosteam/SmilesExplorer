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
        
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            
            if self.smilesExplorerSections?.sectionDetails?[safe: section]?.sectionIdentifier != SmilesExplorerSectionIdentifier.header.rawValue {
                return nil
            }
            
        }
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
            if sectionData.sectionIdentifier != SmilesExplorerSectionIdentifier.topPlaceholder.rawValue && sectionData.sectionIdentifier != SmilesExplorerSectionIdentifier.footer.rawValue {
                
                let header = SmilesExplorerHeader()
                header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""), section: section)
                configureHeaderForShimmer(section: section, headerView: header)
                header.subTitleLabel.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
                
                if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
                    switch SmilesExplorerSectionIdentifier(rawValue: sectionData.sectionIdentifier ?? "") {
                    case .tickets:
                        header.mainView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
                        header.mainView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
                    case .header:
                        header.setupData(title: sectionData.title, subTitle: sectionData.subTitle, color: UIColor(hexString: sectionData.backgroundColor ?? ""), section: section)
                        header.subTitleLabel.textColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
                        header.mainView.backgroundColor = .white
                    default:
                        header.mainView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
                    }
                }
                return header
            }
        }
        
        return nil
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if self.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0 {
            switch self.smilesExplorerSections?.sectionDetails?[safe: section]?.sectionIdentifier {
            case SmilesExplorerSectionIdentifier.header.rawValue:
              return 130
            default:
                return CGFloat.leastNormalMagnitude
            }
            
        }
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
        
        if let sectionData = self.smilesExplorerSections?.sectionDetails?[safe: section] {
            switch SmilesExplorerSectionIdentifier(rawValue: sectionData.sectionIdentifier ?? "") {
            case .tickets:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<ExplorerOfferResponse>) {
                    showHide(isDummy: dataSource.isDummy)
                }
            case .exclusiveDeals:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<ExplorerOfferResponse>) {
                    showHide(isDummy: dataSource.isDummy)
                }
            case .bogoOffers:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<ExplorerOfferResponse>) {
                    showHide(isDummy: dataSource.isDummy)
                }
                
            case .footer:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<SectionDetailDO>) {
                    showHide(isDummy: dataSource.isDummy)
                }
                
            case .header:
                if let dataSource = (self.dataSource?.dataSources?[safe: section] as? TableViewDataSource<SectionDetailDO>) {
                    showHide(isDummy: dataSource.isDummy)
                }
                
            
            default:
                break
            }
        }
        

    }
    
    
    
}
