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
    
    @IBOutlet weak var bottomView: UIView!
    
    
    //MARK: -
    @IBOutlet weak var filtersTableView: UITableView!{
        didSet{
            filtersTableView.sectionFooterHeight = .leastNormalMagnitude
            if #available(iOS 15.0, *) {
                filtersTableView.sectionHeaderTopPadding = CGFloat(0)
            }
            filtersTableView.sectionHeaderHeight = UITableView.automaticDimension
            filtersTableView.estimatedSectionHeaderHeight = 1
            
            filtersTableView.delegate = self
            filtersTableView.dataSource = self
            let smilesExplorerCellRegistrable: CellRegisterable = SmilesExplorerFiltersCellRegistration()
            smilesExplorerCellRegistrable.register(for: filtersTableView)
        }
    }
    
    
    @IBOutlet weak var clearAllButton: UIButton!
    
    @IBOutlet weak var applyFilterButton: UIButton!
    
    // MARK: Properties
    
    
    weak var delegate: SmilesExplorerOffersFiltersDelegate?
    var filterType: FilterType = .All
    var defaultQuickLinkFilter: RestaurantRequestWithNameFilter?
//    var menuType: RestaurantMenuType?
    
    public var homeDelegate: SmilesExplorerHomeDelegate?
    
    init() {
        super.init(nibName: "SmilesExplorerOffersFiltersVC", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        navigationController?.view.backgroundColor = UIColor.white
        setUpNavigationBar()
        
        styleViewUI()
    }
    
     func styleViewUI() {
//        clearAllButton.setTitle("Clearall".localizedString, for: .normal)
        applyFilterButton.setTitle("ApplyTitle".localizedString, for: .normal)
//        clearAllButton.titleLabel?.font = .montserratBoldFont(size: 14.0)
        applyFilterButton.titleLabel?.font = .montserratBoldFont(size: 14.0)
         bottomView.layer.shadowRadius = 2.0
         bottomView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
         bottomView.layer.shadowColor = UIColor.applightGrey.cgColor
         
         
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
        let toptitle: String = "Filters"
        
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
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.clipsToBounds = true
        
        
        let btnClear: UIButton = UIButton(type: .custom)
        btnClear.backgroundColor = .clear
        btnClear.setTitle("Clear", for: .normal)
        btnClear.setTitleColor(.appRevampPurpleMainColor, for: .normal)
        btnClear.addTarget(self, action: #selector(self.onClickClear), for: .touchUpInside)
        btnClear.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.clipsToBounds = true
        
        let leftBarButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightbarButton = UIBarButtonItem(customView: btnClear)
        self.navigationItem.rightBarButtonItem = rightbarButton
        
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    //MARK: - ClickBack
    @objc func onClickBack() {
//        let filterRequest = presenter?.applyFilters()
//        if let filters = filterRequest, !filters.isEmpty {
//            if let delegate = self.delegate {
//                delegate.didReturnRestaurantFilters(filters)
//            }
//        }
         
         SmilesExplorerRouter.shared.popToSmilesExplorerSubscriptionUpgradeViewController(navVC: self.navigationController!)
    }
    
    //MARK: -  Clear all filters
    @objc func onClickClear() {
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




extension SmilesExplorerOffersFiltersVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SmilesExplorerFilterSelectionTVC", for: indexPath) as! SmilesExplorerFilterSelectionTVC
        
        let searchBarcell = tableView.dequeueReusableCell(withIdentifier: "SmilesExplorerFilterTVC", for: indexPath) as! SmilesExplorerFilterTVC
        
        let cellToReturn = indexPath.row == 0 ? searchBarcell : cell
        return cellToReturn
        
    }
    
}
