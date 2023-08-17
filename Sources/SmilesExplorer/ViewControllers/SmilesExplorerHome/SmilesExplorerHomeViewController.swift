//
//  SmilesExplorerHomeViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 15/08/2023.
//

import UIKit
import AppHeader
import Combine
import SmilesUtilities
import SmilesSharedServices
import SmilesLocationHandler

public class SmilesExplorerHomeViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var topHeaderView: AppHeaderView!
    @IBOutlet weak var contentTableView: UITableView!
    
    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var input: PassthroughSubject<SmilesExplorerHomeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerHomeViewModel = {
        return SmilesExplorerHomeViewModel()
    }()
    private let categoryId: Int
    private let isGuestUser: Bool
    private var isUserSubscribed: Bool?
    private var subscriptionType: ExplorerPackage?
    private var voucherCode: String?
    var smilesExplorerSections: GetSectionsResponseModel?
    var sections = [SmilesExplorerSectionData]()
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    public init(categoryId: Int, isGuestUser: Bool, isUserSubscribed: Bool? = nil, subscriptionType: ExplorerPackage? = nil, voucherCode: String? = nil) {
        self.categoryId = categoryId
        self.isGuestUser = isGuestUser
        self.isUserSubscribed = isUserSubscribed
        self.subscriptionType = subscriptionType
        self.voucherCode = voucherCode
        super.init(nibName: "SmilesExplorerHomeViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        setupTableView()
        bind(to: viewModel)
        setupHeaderView(headerTitle: nil)
//        if let isUserSubscribed {
            getSections(isSubscribed: false)
//        } else {
//            self.input.send(.getRewardPoints)
//        }
        
    }
    
    private func setupTableView() {
        
        contentTableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            contentTableView.sectionHeaderTopPadding = CGFloat(0)
        }
        contentTableView.sectionHeaderHeight = UITableView.automaticDimension
        contentTableView.estimatedSectionHeaderHeight = 1
        contentTableView.delegate = self
        let smilesExplorerCellRegistrable: CellRegisterable = SmilesExplorerHomeCellRegistration()
        smilesExplorerCellRegistrable.register(for: contentTableView)
        
    }
    
    private func setupHeaderView(headerTitle: String?) {
        topHeaderView.delegate = self
        topHeaderView.setupHeaderView(backgroundColor: .appRevampEnableStateColor, searchBarColor: .white, pointsViewColor: nil, titleColor: .black, headerTitle: headerTitle.asStringOrEmpty(), showHeaderNavigaton: true, haveSearchBorder: true, shouldShowBag: false, isGuestUser: isGuestUser, showHeaderContent: isUserSubscribed ?? false, toolTipInfo: nil)
    }
    
    fileprivate func configureDataSource() {
        self.contentTableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
    
    private func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        
        smilesExplorerSections = sectionsResponse
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        if let topPlaceholderSection = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSectionIdentifier.topPlaceholder.rawValue }) {
            setupHeaderView(headerTitle: topPlaceholderSection.title)
            topHeaderView.setHeaderTitleIcon(iconURL: topPlaceholderSection.iconUrl)
        }
        homeAPICalls()
        
    }
    
    private func setupUI() {
        self.contentTableView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
        self.contentTableView.backgroundColor = .white
        self.sections.removeAll()
        self.homeAPICalls()
    }
    
    func getSectionIndex(for identifier: SmilesExplorerSectionIdentifier) -> Int? {
        
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
        
    }

}

// MARK: - VIEWMODEL BINDING -
extension SmilesExplorerHomeViewController {
    
    func bind(to viewModel: SmilesExplorerHomeViewModel) {
        input = PassthroughSubject<SmilesExplorerHomeViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                case .fetchSectionsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchRewardPointsDidSucceed(response: let response, _):
                    self?.isUserSubscribed = response.explorerSubscriptionStatus
                    self?.getSections(isSubscribed: response.explorerSubscriptionStatus ?? false)
                    self?.subscriptionType = response.explorerPackageType
                    self?.voucherCode = response.explorerVoucherCode
                    
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchFiltersDataSuccess(let filters, let selectedSortingTableViewCellModel):
//                    self?.filtersData = filters
//                    self?.selectedSortingTableViewCellModel = selectedSortingTableViewCellModel
                    break
                case .fetchAllSavedFiltersSuccess(let filtersList, let savedFilters):
//                    self?.savedFilters = filtersList
//                    self?.filtersSavedList = savedFilters
//                    self?.offers.removeAll()
//                    self?.configureDataSource()
//                    self?.configureFiltersData()
                    break
                case .fetchSavedFiltersAfterSuccess(let filtersSavedList):
//                    self?.filtersSavedList = filtersSavedList
                    break
                case .fetchSortingListDidSucceed:
//                    self?.configureSortingData()
                    break
                case .fetchContentForSortingItems(let baseRowModels):
//                    self?.sortingListRowModels = baseRowModels
                    break
//                case .updateWishlistStatusDidSucceed(let updateWishlistResponse):
//                    self?.configureWishListData(with: updateWishlistResponse)
                    
//                case .updateWishlistStatusDidFail(let error):
//                    print(error.localizedDescription)
                case .fetchTopOffersDidSucceed(response: let response):
//                    self?.configureBannersData(with: response, sectionIdentifier: .inviteFriends)
                    break
                    
                default: break
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - SERVER CALLS -
extension SmilesExplorerHomeViewController {
    
    private func getSections(isSubscribed: Bool) {
        self.input.send(.getSections(categoryID: categoryId, type: isSubscribed ? "SUBSCRIBED" : "UNSUBSCRIBED"))
    }
    
    private func homeAPICalls() {
        
        if let sectionDetails = self.smilesExplorerSections?.sectionDetails, !sectionDetails.isEmpty {
            sections.removeAll()
            for (index, element) in sectionDetails.enumerated() {
                guard let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty else {
                    return
                }
                if let section = SmilesExplorerSectionIdentifier(rawValue: sectionIdentifier), section != .topPlaceholder {
                    sections.append(SmilesExplorerSectionData(index: index, identifier: section))
                }
                switch SmilesExplorerSectionIdentifier(rawValue: sectionIdentifier) {
                case .header:
                    configureHeaderSection()
                default: break
                }
            }
        }
    }
    
}

// MARK: - SECTIONS CONFIGURATIONS -
extension SmilesExplorerHomeViewController {
    
    private func configureHeaderSection() {
        
        if let headerSectionIndex = getSectionIndex(for: .header) {
            dataSource?.dataSources?[headerSectionIndex] = TableViewDataSource(models: [], reuseIdentifier: "", data: "#FFFFFF", cellConfigurator: { _, _, _, _ in })
            configureDataSource()
        }
        
    }
    
}

// MARK: - APP HEADER DELEGATE -
extension SmilesExplorerHomeViewController: AppHeaderDelegate {
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
