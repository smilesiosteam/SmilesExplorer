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
import SmilesOffers
import SmilesLoader

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
    
    public var delegate:SmilesExplorerHomeDelegate? = nil
    var offersListing: ExplorerOfferResponse?
    var offersPage = 1 // For offers list pagination
    var dodOffersPage = 1 // For DOD offers list pagination
    var offers = [ExplorerOffer]()
    var tickets = [ExplorerOffer]()
    var bogoOffer = [ExplorerOffer]()
    var dodOffers = [OfferDO]()
    private var selectedIndexPath: IndexPath?
    
    var categoryDetailsSections: GetSectionsResponseModel?
    
    var mutatingSectionDetails = [SectionDetailDO]()
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    public override func viewDidLoad() {
        super.viewDidLoad()
        SmilesLoader.show(on: self.view)
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
                    
                case .fetchFiltersDataSuccess(_, _):
//                    self?.filtersData = filters
//                    self?.selectedSortingTableViewCellModel = selectedSortingTableViewCellModel
                    break
                case .fetchAllSavedFiltersSuccess(_, _):
//                    self?.savedFilters = filtersList
//                    self?.filtersSavedList = savedFilters
//                    self?.offers.removeAll()
//                    self?.configureDataSource()
//                    self?.configureFiltersData()
                    break
                case .fetchTicketsDidSucceed(let exclusiveOffers):
                    self?.configureTickets(with: exclusiveOffers)
                    break
                case .fetchSavedFiltersAfterSuccess(_):
//                    self?.filtersSavedList = filtersSavedList
                    break
                case .fetchExclusiveOffersDidSucceed(let exclusiveOffers):
                    self?.configureExclusiveOffers(with: exclusiveOffers)
                   
                    break
                    
                case .fetchBogoDidSucceed(let exclusiveOffers):
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    self?.configureBogoOffers(with: exclusiveOffers)
                    
                case .fetchContentForSortingItems(_):
//                    self?.sortingListRowModels = baseRowModels
                    break
//                case .updateWishlistStatusDidSucceed(let updateWishlistResponse):
//                    self?.configureWishListData(with: updateWishlistResponse)
                    
//                case .updateWishlistStatusDidFail(let error):
//                    print(error.localizedDescription)
                case .fetchTopOffersDidSucceed(response: _):
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
                case .footer:
                    configureFooterSection()
                case .tickets:
                    self.input.send(.getTickets(categoryId: self.categoryId, tag: sectionIdentifier, pageNo: 0))
                    break
                case .exclusiveDeals:
                    self.input.send(.exclusiveDeals(categoryId: self.categoryId, tag: sectionIdentifier, pageNo: 0))
                    break
                case .bogoOffers:
                    self.input.send(.getBogo(categoryId: self.categoryId, tag: sectionIdentifier, pageNo: 0))
                    break
                case .topPlaceholder:
                    break
                    
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
    
    private func configureFooterSection() {
        
        if let footerSectionIndex = getSectionIndex(for: .footer) {
            if let footer = smilesExplorerSections?.sectionDetails?.first(where: { section in
                return section.sectionIdentifier == SmilesExplorerSectionIdentifier.footer.rawValue
            }), let backgroundImage = footer.backgroundImage {
                dataSource?.dataSources?[footerSectionIndex] = TableViewDataSource(models: [backgroundImage], reuseIdentifier: "SmilesExplorerFooterTableViewCell", data: "#FFFFFF", cellConfigurator: { (url, cell, data, indexPath) in
                    guard let cell = cell as? SmilesExplorerFooterTableViewCell else { return }
                    cell.footerconfiguration = self.smilesExplorerSections?.sectionDetails?.last
                    cell.setupValues(url: url)
                    cell.getMembership = { [weak self] in
                        // Setup navigation for membership
                        SmilesExplorerRouter.shared.pushSubscriptionVC(navVC: self?.navigationController, delegate: self?.delegate)
                    }
                })
                configureDataSource()
            }
        }
        
    }
    
    fileprivate func configureExclusiveOffers(with exclusiveOffersResponse: ExplorerOfferResponse) {
        self.offersListing = exclusiveOffersResponse
        self.offers.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if !offers.isEmpty {
            if let offersCategoryIndex = getSectionIndex(for: .exclusiveDeals) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forOffers: self.offersListing ?? ExplorerOfferResponse(), data: self.smilesExplorerSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] explorerOffer in
                    print(explorerOffer)
                    
                })
                self.configureDataSource()
            }
        } else {
            if self.offers.isEmpty {
                self.configureHideSection(for: .exclusiveDeals, dataSource: ExplorerOffer.self)
            }
        }
    }
    
    
    fileprivate func configureTickets(with exclusiveOffersResponse: ExplorerOfferResponse) {
        self.offersListing = exclusiveOffersResponse
        self.tickets.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if !tickets.isEmpty {
            if let offersCategoryIndex = getSectionIndex(for: .tickets) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forOffers: self.offersListing ?? ExplorerOfferResponse(), data: self.smilesExplorerSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#555555", completion: { [weak self] explorerOffer in
                    print(explorerOffer)
                    
                })
                self.configureDataSource()
            }
        } else {
            if self.tickets.isEmpty {
                self.configureHideSection(for: .exclusiveDeals, dataSource: ExplorerOffer.self)
            }
        }
    }
    
    
    fileprivate func configureBogoOffers(with exclusiveOffersResponse: ExplorerOfferResponse) {
        self.offersListing = exclusiveOffersResponse
        self.bogoOffer.append(contentsOf: exclusiveOffersResponse.offers ?? [])
//        let offers = getAllOffers(exclusiveOffersResponse: exclusiveOffersResponse)
        if !bogoOffer.isEmpty {
            if let offersCategoryIndex = getSectionIndex(for: .bogoOffers) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forOffers: self.offersListing ?? ExplorerOfferResponse(), data: self.smilesExplorerSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] explorerOffer in
                    print(explorerOffer)
                    
                })
                self.configureDataSource()
            }
        } else {
            if self.bogoOffer.isEmpty {
                self.configureHideSection(for: .exclusiveDeals, dataSource: ExplorerOffer.self)
            }
        }
    }
    
    
    
    
    
//    private func getAllOffers(exclusiveOffersResponse: ExplorerOfferResponse) -> [ExplorerOffer] {
//
//        let featuredOffers = exclusiveOffersResponse.offers?.map({ offer in
//            var _offer = offer
//            _offer.isFeatured = true
//            return _offer
//        })
//        var offers = [ExplorerOffer]()
//        if self.offersPage == 1 {
//            offers.append(contentsOf: featuredOffers ?? [])
//        }
//        offers.append(contentsOf: exclusiveOffersResponse.offers ?? [])
//        return offers
//
//    }
    
    fileprivate func configureHideSection<T>(for section: SmilesExplorerSectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            self.mutatingSectionDetails.removeAll(where: { $0.sectionIdentifier == section.rawValue })
            
            self.configureDataSource()
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

