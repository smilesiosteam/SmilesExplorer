//
//  File.swift
//  
//
//  Created by Habib Rehman on 14/09/2023.
//

import Foundation
import UIKit
import SmilesUtilities

enum FilterType {
    case All
    case RestaurantListing
}

protocol RestaurantFiltersDelegate: AnyObject {
    func didReturnRestaurantFilters(_ restaurantFilters: [RestaurantRequestWithNameFilter])
}

class SmilesExplorerOffersFiltersVC: UIViewController, SmilesCoordinatorBoard {
    
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var clearAllButton: ButtonSecondary!
    @IBOutlet weak var applyFilterButton: ButtonPrimary!

    // MARK: Properties
    
    var presenter: RestaurantFilterPresentation?
    weak var delegate: RestaurantFiltersDelegate?
    var filterType: FilterType = .All
    var defaultQuickLinkFilter: RestaurantRequestWithNameFilter?
    var menuType: RestaurantMenuType?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.view.backgroundColor = UIColor.white

        setNavigationBarTitle("Filters".localizedString, withLargeTitles: true)
        
        presenter?.setFilterType(forFilterType: filterType, defaultQuickLinkFilter: defaultQuickLinkFilter, menuTpye: menuType) // Set filter type, if it comes from listing or all category.
        
        presenter?.viewDidLoad()
    }
    
    override func styleViewUI() {
        clearAllButton.setTitle("Clearall".localizedString, for: .normal)
        applyFilterButton.setTitle("ApplyTitle".localizedString, for: .normal)
        clearAllButton.titleLabel?.font = .montserratBoldFont(size: 14.0)
        applyFilterButton.titleLabel?.font = .montserratBoldFont(size: 14.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 1.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 5.0
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        }
        
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.07).cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 0.0
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.0
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func onClickBack() {
        let filterRequest = presenter?.applyFilters()
        if let filters = filterRequest, !filters.isEmpty {
            if let delegate = self.delegate {
                delegate.didReturnRestaurantFilters(filters)
            }
        }
    }

}

extension SmilesExplorerOffersFiltersVC: RestaurantFilterView {
    // TODO: implement view output methods
    
    func setUpTableView(withSectionsModels: [BaseSectionModel], delegate: RestaurantFilterPresenter) {
        setUpTableViewSectionsDataSource(dataSource: withSectionsModels, delegate: delegate, tableView: self.filtersTableView)
    }
    
    func reloadTableViewWithIndividualSection(withSectionNumber:Int,withSectionsModels: [BaseSectionModel], delegate: RestaurantFilterPresenter){
        reloadIndividualSectionOfTableViewOnly(dataSource: withSectionsModels, delegate: delegate, tableView: self.filtersTableView, sectionNumber: withSectionNumber)
    }
    
}

extension SmilesExplorerOffersFiltersVC {
    
    // Clear all filters
    @IBAction func clearAllFiltersAction(_ sender: Any) {
        presenter?.clearAllFilters()
    }
    
    // Apply filters
    @IBAction func applyFilterAction(_ sender: Any) {
        let filterRequest = presenter?.applyFilters()
        if let filters = filterRequest {
            if let delegate = self.delegate {
                delegate.didReturnRestaurantFilters(filters)
            }
        }
    }
}
