//
//  File.swift
//  
//
//  Created by Habib Rehman on 14/09/2023.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesSharedServices

enum FilterType {
    case All
    case RestaurantListing
}

protocol SmilesExplorerOffersFiltersDelegate: AnyObject {
    func didReturnOffersFilters(_ restaurantFilters: [RestaurantRequestWithNameFilter])
}

class SmilesExplorerOffersFiltersVC: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var applyFilterButton: UIButton!

    // MARK: Properties
    
    
    weak var delegate: SmilesExplorerOffersFiltersDelegate?
    var filterType: FilterType = .All
    var defaultQuickLinkFilter: RestaurantRequestWithNameFilter?
//    var menuType: RestaurantMenuType?

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        navigationController?.view.backgroundColor = UIColor.white
        setUpNavigationBar()
        
        
    }
    
     func styleViewUI() {
        clearAllButton.setTitle("Clearall".localizedString, for: .normal)
        applyFilterButton.setTitle("ApplyTitle".localizedString, for: .normal)
        clearAllButton.titleLabel?.font = .montserratBoldFont(size: 14.0)
        applyFilterButton.titleLabel?.font = .montserratBoldFont(size: 14.0)
    }
    
    func setUpNavigationBar() {
        
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.tintColor = .black
        var toptitle: String = "Filters"
        
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = toptitle
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_icon_ar" : "back_Icon", in: .module, compatibleWith: nil), for: .normal)
//        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.clipsToBounds = true
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
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
    
    
    //MARK: - ClickBack
     func onClickBack() {
//        let filterRequest = presenter?.applyFilters()
//        if let filters = filterRequest, !filters.isEmpty {
//            if let delegate = self.delegate {
//                delegate.didReturnRestaurantFilters(filters)
//            }
//        }
    }
    
    //MARK: -  Clear all filters
    @IBAction func clearAllFiltersAction(_ sender: Any) {
//        presenter?.clearAllFilters()
    }
    
    //MARK: - Apply filters
    @IBAction func applyFilterAction(_ sender: Any) {
//        let filterRequest = presenter?.applyFilters()
//        if let filters = filterRequest {
//            if let delegate = self.delegate {
//                delegate.didReturnRestaurantFilters(filters)
//            }
//        }
    }

}




