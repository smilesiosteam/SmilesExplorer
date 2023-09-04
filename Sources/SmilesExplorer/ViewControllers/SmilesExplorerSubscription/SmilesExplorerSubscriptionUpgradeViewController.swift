//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 04/09/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import AppHeader
import SmilesLocationHandler

public class SmilesExplorerSubscriptionUpgradeViewController: UIViewController {
    
    @IBOutlet weak var topHeaderView: AppHeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upgradeNowButton: UIButton!
    
    var dataSource: SectionedTableViewDataSource?
    var sections = [SmilesExplorerSubscriptionUpgradeSectionData]()
    var smilesExplorerSections: GetSectionsResponseModel?
    private let categoryId: Int
    private let isGuestUser: Bool
    private var isUserSubscribed: Bool?
    private var subscriptionType: ExplorerPackage?
    private var voucherCode: String?
    
    public init(categoryId: Int, isGuestUser: Bool, isUserSubscribed: Bool? = nil, subscriptionType: ExplorerPackage? = nil, voucherCode: String? = nil) {
        self.categoryId = categoryId
        self.isGuestUser = isGuestUser
        self.isUserSubscribed = isUserSubscribed
        self.subscriptionType = subscriptionType
        self.voucherCode = voucherCode
        super.init(nibName: "SmilesExplorerSubscriptionUpgradeViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
    }
    
    // MARK: - Helping Functions
    
    func setupTableView() {
        self.tableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = CGFloat(0)
        }
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        
        let customizable: CellRegisterable? = SmilesExplorerSubscriptionUpgradeCellRegistration()
        customizable?.register(for: self.tableView)
        
        // ----- Tableview section header hide in case of tableview mode Plain ---
        let dummyViewHeight = CGFloat(150)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        // ----- Tableview section header hide in case of tableview mode Plain ---
    }
    
    fileprivate func configureDataSource() {
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    func getSectionIndex(for identifier: SmilesExplorerSubscriptionUpgradeSectionIdentifier) -> Int? {
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
    }
    
    private func setupUI() {
        self.tableView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
        self.tableView.backgroundColor = .white
        self.sections.removeAll()
//        self.homeAPICalls()
    }
    
    private func setupHeaderView(headerTitle: String?) {
        topHeaderView.delegate = self
        topHeaderView.setupHeaderView(backgroundColor: .appRevampEnableStateColor, searchBarColor: .white, pointsViewColor: nil, titleColor: .black, headerTitle: headerTitle.asStringOrEmpty(), showHeaderNavigaton: true, haveSearchBorder: true, shouldShowBag: false, isGuestUser: isGuestUser, showHeaderContent: isUserSubscribed ?? false, toolTipInfo: nil)
    }
}

// MARK: - APP HEADER DELEGATE -
extension SmilesExplorerSubscriptionUpgradeViewController: AppHeaderDelegate {
    public func didTapOnBackButton() {
        navigationController?.popViewController()
    }
    
    public func didTapOnSearch() {
//        self.input.send(.didTapSearch)
//        let analyticsSmiles = AnalyticsSmiles(service: FirebaseAnalyticsService())
//        analyticsSmiles.sendAnalyticTracker(trackerData: Tracker(eventType: AnalyticsEvent.firebaseEvent(.SearchBrandDirectly).name, parameters: [:]))
    }
    
    public func didTapOnLocation() {
//        self.foodOrderHomeCoordinator?.navigateToUpdateLocationVC(confirmLocationRedirection: .toFoodOrder)
    }
    
    func showPopupForLocationSetting() {
        LocationManager.shared.showPopupForSettings()
    }
    
    func didTapOnToolTipSearch() {
//        redirectToSetUserLocation()
    }
    
    public func segmentLeftBtnTapped(index: Int) {
//        configureOrderType(with: index)
    }
    
    public func segmentRightBtnTapped(index: Int) {
//        configureOrderType(with: index)
    }
    
    public func rewardPointsBtnTapped() {
//        self.foodOrderHomeCoordinator?.navigateToTransactionsListViewController()
    }
    
    public func didTapOnBagButton() {
//        self.orderHistorViewAll()
    }
}

