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
import Combine
import SmilesOffers
import SmilesLoader
import SmilesStoriesManager
import AnalyticsSmiles
import SmilesBanners
import SmilesFilterAndSort

enum OfferSort: String, CaseIterable {
    case discount = "Discounts"
    case voucher = "Vouchers"
    case dealVouchers = "DealVouchers"
}

public class SmilesExplorerSubscriptionUpgradeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var topHeaderView: AppHeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upgradeNowButton: UIButton!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    var selectedLocation: String? = nil
    var isHeaderExpanding = false
    var viewModel: SmilesTouristHomeViewModel!
    var dataSource: SectionedTableViewDataSource?
    var sections = [SmilesExplorerSubscriptionUpgradeSectionData]()
    var smilesExplorerSections: GetSectionsResponseModel?
    var mutatingSectionDetails = [SectionDetailDO]()
    var selectedFiltersResponse: Data?
    var restaurants = [Restaurant]()
    var offersListing: OffersCategoryResponseModel?
    var bogooffersListing: OffersCategoryResponseModel?
    var offersPage = 1 // For offers list pagination
    var dodOffersPage = 1 // For DOD offers list pagination
    var offers = [OfferDO]()
    var bogoOffers = [OfferDO]()
    
    private var offerFavoriteOperation = 0
    private var cancellables = Set<AnyCancellable>()
    public var delegate:SmilesExplorerHomeDelegate? = nil
    private var selectedIndexPath: IndexPath?
    private var rewardPoint: Int?
    private var rewardPointIcon: String?
    private var personalizationEventSource: String?
    private var platinumLimiReached: Bool?
    
    public   var offersCategoryId = 0
    public  var sortOfferBy: String?
    public  var sortingType: String?
    public  var lastSortCriteria: String?
    public  var arraySelectedSubCategoryPaths: [IndexPath] = []
    public  var arraySelectedSubCategoryTypes: [String] = []
    public  var filterValues: [FilterValue] = []
    public var selectedSortTypeIndex: Int?
    public var didSelectFilterOrSort = false
    public var filtersSavedList: [RestaurantRequestWithNameFilter]?
    public var filtersData: [FiltersCollectionViewCellRevampModel]?
    public var savedFilters: [RestaurantRequestFilter]?
    public var restaurantSortingResponseModel: GetSortingListResponseModel?
    public var selectedSortingTableViewCellModel: FilterDO?
    private var onFilterClick:(() -> Void)?
    public var filtersList: [RestaurantRequestFilter]?
    public var selectedSort: String?
    
    
    // MARK: - For TopSpace in X series
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    // MARK: - initializer
    init(viewModel: SmilesTouristHomeViewModel, delegate:SmilesExplorerHomeDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: "SmilesExplorerSubscriptionUpgradeViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    public override func viewDidLoad() {
        setupTableView()
        bind(to: viewModel)
        if viewModel.isUserSubscribed != nil {
            self.getSections(isSubscribed: viewModel.isUserSubscribed ?? false, explorerPackageType: viewModel.subscriptionType ?? .gold, freeTicketAvailed: viewModel.voucherCode != nil ? true:false,platinumLimiReached: viewModel.platinumLimiReached)
        } else {
            viewModel.getRewardPoint()
        }
        selectedLocation = LocationStateSaver.getLocationInfo()?.locationId
        if self.viewModel.subscriptionType == .platinum || self.viewModel.platinumLimiReached == true{
            self.upgradeNowButton.isHidden = true
        }else{
            self.upgradeNowButton.isHidden = false
            self.upgradeNowButton.fontTextStyle = .smilesHeadline4
            self.upgradeNowButton.backgroundColor = .appRevampPurpleMainColor
            self.upgradeNowButton.setTitle("Upgrade Now".localizedString, for: .normal)
        }
        self.setupHeaderView(headerTitle: "")
        let imageName = "back_arrow"
        self.topHeaderView.setCustomImageForBackButton(imageName: imageName)
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let currentLocationId = LocationStateSaver.getLocationInfo()?.locationId, let locationId = self.selectedLocation, currentLocationId != locationId {
            selectedLocation = LocationStateSaver.getLocationInfo()?.locationId
        }
        
    }
    // MARK: - setupTableView
    func setupTableView() {
        self.tableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = CGFloat(0)
        }
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        tableView.delegate = self
        let customizable: CellRegisterable? = SmilesExplorerSubscriptionUpgradeCellRegistration()
        customizable?.register(for: self.tableView)
        self.tableView.backgroundColor = .white
        // ----- Tableview section header hide in case of tableview mode Plain ---
        let dummyViewHeight = CGFloat(150)
        self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        self.tableView.contentInset = UIEdgeInsets(top: -dummyViewHeight, left: 0, bottom: 0, right: 0)
        // ----- Tableview section header hide in case of tableview mode Plain ---
    }
    
    //MARK: - Navigation Bar Setup
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
        var toptitle: String = "Smiles Tourist"
        if let topPlaceholderSection = self.smilesExplorerSections?.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.topPlaceholder.rawValue }) {
            imageView.sd_setImage(with: URL(string: topPlaceholderSection.iconUrl ?? "")) { image, _, _, _ in
                imageView.image = image?.withRenderingMode(.alwaysTemplate)
                toptitle = topPlaceholderSection.title ?? toptitle
            }
        }
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = toptitle
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = UIColor.clear
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.clipsToBounds = true
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.topHeaderView.isHidden = true
        if hasTopNotch {
            self.tableViewTopConstraint.constant = ((-212) + ((self.navigationController?.navigationBar.frame.height ?? 0.0)))
        } else{
            self.tableViewTopConstraint.constant = ((-212) + ((self.navigationController?.navigationBar.frame.height ?? 0.0)-30.0))
        }
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    //MARK: - onClickBack
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: - onUpgradeBannerButtonClick()
    @IBAction func onUpgradeBannerButtonClick() {
        SmilesExplorerRouter.shared.showPickTicketPop(viewcontroller: self ,delegate: delegate)
    }
    //MARK: - configureDataSource()
    fileprivate func configureDataSource() {
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    //MARK: - getSectionIndex()
    func getSectionIndex(for identifier: SmilesExplorerSubscriptionUpgradeSectionIdentifier) -> Int? {
        return sections.first(where: { obj in
            return obj.identifier == identifier
        })?.index
    }
    //MARK: - setupUI()
    private func setupUI() {
        
        self.tableView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
        self.tableView.backgroundColor = .white
        self.sections.removeAll()
    }
    // MARK: - Top Header
    private func setupHeaderView(headerTitle: String?) {
        topHeaderView.delegate = self
        topHeaderView.setupHeaderView(backgroundColor: .white, searchBarColor: .white, pointsViewColor: .black.withAlphaComponent(0.1), titleColor: .black, headerTitle: headerTitle.asStringOrEmpty(), showHeaderNavigaton: true, haveSearchBorder: true, shouldShowBag: false, isGuestUser: self.viewModel.isGuestUser ?? false, showHeaderContent: self.viewModel.isUserSubscribed ?? false)
        displayRewardPoints()
    }
    
    func displayRewardPoints() {
        if let rewardPoints = viewModel.rewardPoint {
            self.topHeaderView.setPointsOfUser(with: rewardPoints.numberWithCommas())
        }
        if let rewardPointsIcon = viewModel.rewardPointIcon {
            self.topHeaderView.setPointsIcon(with: rewardPointsIcon, shouldShowAnimation: false)
        }
    }
    
    func adjustTopHeader(_ scrollView: UIScrollView) {
        guard isHeaderExpanding == false else {return}
        if let tableView = scrollView as? UITableView {
            let items = (0..<tableView.numberOfSections).reduce(into: 0) { partialResult, sectionIndex in
                partialResult += tableView.numberOfRows(inSection: sectionIndex)
            }
            if items == 0 {
                return
            }
        }
        let isAlreadyCompact = !topHeaderView.bodyViewCompact.isHidden
        let compact = scrollView.contentOffset.y > 150
        if compact != isAlreadyCompact {
            isHeaderExpanding = true
            topHeaderView.adjustUI(compact: compact,isBackgroundColorClear: true)
            topHeaderView.view_container.backgroundColor = .white
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
                self.isHeaderExpanding = false
            }
        }
    }
    
    private func updateView(index: Int) {
        //self?.adjustTopHeader(scrollView)
    }
    
    public func configureFiltersData() {
        if let filtersSavedList = self.filtersSavedList {
            arraySelectedSubCategoryTypes = []
            arraySelectedSubCategoryPaths = []
            
            for filter in filtersSavedList {
                arraySelectedSubCategoryTypes.append(filter.filterValue ?? "")
                arraySelectedSubCategoryPaths.append(filter.indexPath ?? IndexPath())
            }
        }
        self.viewModel.emptyOffers()
        self.showShimmer(identifier: .offerListing)
        self.viewModel.getOffers(tag: .bogoOffers, pageNo: 1, categoryTypeIdsList: self.arraySelectedSubCategoryTypes)
    }
    
    public func setSavedFilterForCordinator(filtersSavedList: [RestaurantRequestWithNameFilter]?, filtersList: [RestaurantRequestFilter]?){
        self.viewModel.setFiltersSavedList(filtersSavedList: filtersSavedList, filtersList: filtersList)
    }
    
}


// MARK: - APP HEADER DELEGATE -
extension SmilesExplorerSubscriptionUpgradeViewController: AppHeaderDelegate {
    
    public func didTapOnBackButton() {
        navigationController?.popViewController()
    }
    
    public func didTapOnSearch() {
        self.delegate?.navigateToGlobalSearch()
    }
    
    public func didTapOnLocation() {
        self.delegate?.navigateToLocation()
    }
    
    func setLocationToolTipPositionView(view: UIImageView) {
        //        self.locationToolTipPosition = view
    }
    
    public func segmentLeftBtnTapped(index: Int) {
        updateView(index: index)
    }
    
    public func segmentRightBtnTapped(index: Int) {
        updateView(index: index)
    }
    
    @IBAction func upgradeTapped(_ sender: Any){
        SmilesExplorerRouter.shared.showPickTicketPop(viewcontroller: self, delegate: self.delegate)
    }
    
    public func rewardPointsBtnTapped() {
        self.delegate?.navigateToRewardPoint(personalizationEventSource: self.personalizationEventSource)
    }
}

extension SmilesExplorerSubscriptionUpgradeViewController {
    // MARK: - Get Sections Api Calls
    private func getSections(isSubscribed: Bool, explorerPackageType: ExplorerPackage,freeTicketAvailed:Bool,platinumLimiReached: Bool? = nil) {
        self.viewModel.getSections(type: isSubscribed ? ExplorerSubscriptionTypeConstant.subscribed : ExplorerSubscriptionTypeConstant.unsubscribed, explorerPackageType: explorerPackageType, freeTicketAvailed: freeTicketAvailed, platinumLimiReached: platinumLimiReached)
    }
    
    // MARK: - HomeApi Calls
    private func homeAPICalls() {
        
        if let sectionDetails = self.smilesExplorerSections?.sectionDetails, !sectionDetails.isEmpty {
            sections.removeAll()
            for (index, element) in sectionDetails.enumerated() {
                guard let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty else {
                    return
                }
                if let section = SmilesExplorerSubscriptionUpgradeSectionIdentifier(rawValue: sectionIdentifier), section != .topPlaceholder {
                    sections.append(SmilesExplorerSubscriptionUpgradeSectionData(index: index, identifier: section))
                }
                switch SmilesExplorerSubscriptionUpgradeSectionIdentifier(rawValue: sectionIdentifier) {
                    
                case .upgradeBanner:
                    if let bannerIndex = getSectionIndex(for: .upgradeBanner) {
                        guard let bannerSectionData = self.smilesExplorerSections?.sectionDetails?[bannerIndex] else {return}
                        self.configureUpgardeBanner(with: bannerSectionData, index: bannerIndex)
                    }
                    
                case .freetickets:
                    if let bannerIndex = getSectionIndex(for: .freetickets) {
                        guard let bannerSectionData = self.smilesExplorerSections?.sectionDetails?[bannerIndex] else {return}
                        self.configureUpgardeBanner(with: bannerSectionData, index: bannerIndex)
                    }
                    break
                case .stories:
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forStories: response, data:"#FFFFFF", isDummy: true, onClick:nil)
                    }
                    self.viewModel.getOffers(tag: .exclusiveDeals)
                    break
                case .offerListing:
                    if let response = OfferDO.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forBogoOffers: [response], data:"#FFFFFF", isDummy: true, completion:nil)
                    }
                    self.viewModel.getOffers(tag: .bogoOffers,categoryTypeIdsList: self.arraySelectedSubCategoryTypes.isEmpty  ? nil: self.arraySelectedSubCategoryTypes)
                    break
                    
                default: break
                }
            }
        }
    }
    
    
    // MARK: - Section Data
    private func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        smilesExplorerSections = sectionsResponse
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
        }
        
        if let topPlaceholderSection = sectionsResponse.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSubscriptionUpgradeSectionIdentifier.topPlaceholder.rawValue }) {
            setupHeaderView(headerTitle: topPlaceholderSection.title)
            if let iconURL = topPlaceholderSection.iconUrl {
                self.topHeaderView.headerTitleImageView.isHidden = false
                self.topHeaderView.setHeaderTitleIcon(iconURL: iconURL)
            }
            let imageName = "back_arrow"
            self.topHeaderView.setCustomImageForBackButton(imageName: imageName)
            if self.viewModel.subscriptionType == .platinum || self.viewModel.platinumLimiReached == true{
                self.upgradeNowButton.isHidden = true
            }else{
                self.upgradeNowButton.isHidden = false
            }
            self.configureDataSource()
            homeAPICalls()
            
        }
        
    }
    
    func updateOfferWishlistStatus(isFavorite: Bool, offerId: String) {
        offerFavoriteOperation = isFavorite ? 1 : 2
        self.viewModel.updateOfferWishlistStatus(operation: offerFavoriteOperation, offerId: offerId)
    }
}


extension SmilesExplorerSubscriptionUpgradeViewController {
    
    // MARK: - Section Data
    func bind(to viewModel: SmilesTouristHomeViewModel) {
        let output = viewModel.output
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                    
                case .fetchSectionsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchRewardPointsDidSucceed(response: let response, _):
                    self?.viewModel.isUserSubscribed = response.explorerSubscriptionStatus
                    self?.getSections(isSubscribed: response.explorerSubscriptionStatus ?? false, explorerPackageType: response.explorerPackageType ?? .gold, freeTicketAvailed: response.explorerVoucherCode != nil ? true:false,platinumLimiReached: response.platinumLimitReached)
                    self?.viewModel.subscriptionType = response.explorerPackageType
                    self?.viewModel.voucherCode = response.explorerVoucherCode
                    if response.explorerPackageType ?? .gold == .platinum {
                        self?.upgradeNowButton.isHidden = true
                    }
                    
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchFiltersDataSuccess(let filters, let selectedSortingTableViewCellModel):
                    self?.filtersData = filters
                    self?.selectedSortingTableViewCellModel = selectedSortingTableViewCellModel
                    break
                case .fetchAllSavedFiltersSuccess(let filtersList, let savedFilters):
                    self?.savedFilters?.removeAll()
                    self?.offers.removeAll()
                    self?.filtersSavedList?.removeAll()
                    self?.savedFilters = filtersList
                    self?.filtersSavedList = savedFilters
                    
                    self?.configureDataSource()
                    self?.configureFiltersData()
                case .updateWishlistStatusDidSucceed(let updateWishlistResponse):
                    self?.configureWishListData(with: updateWishlistResponse)
                    
                case .updateWishlistStatusDidFail(let error):
                    print(error.localizedDescription)
                    
                case .fetchExclusiveOffersDidSucceed(let exclusiveOffersStories):
                    self?.configureExclusiveOffersStories(with: exclusiveOffersStories)
                    
                case .fetchExclusiveOffersDidFail(let error):
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .stories, dataSource: OffersCategoryResponseModel.self)
                case .fetchBogoOffersDidSucceed(response: let bogoOffers):
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    self?.configureBogoOffers(with: bogoOffers)
                    
                case .fetchBogoOffersDidFail(error: let error):
                    self?.configureHideSection(for: .offerListing, dataSource: OfferDO.self)
                    debugPrint(error.localizedDescription)
                    
                case .emptyOffersListDidSucceed:
                    self?.offersPage = 1
                    self?.bogoOffers.removeAll()
                    self?.configureDataSource()
                    
                default: break
                }
            }.store(in: &cancellables)
    }
    
}
extension SmilesExplorerSubscriptionUpgradeViewController {
    
    // MARK: - SECTIONS CONFIGURATIONS -
    private func configureHeaderSection() {
        if let headerSectionIndex = getSectionIndex(for: .stories) {
            dataSource?.dataSources?[headerSectionIndex] = TableViewDataSource(models: [], reuseIdentifier: "", data: "#FFFFFF", cellConfigurator: { _, _, _, _ in })
            configureDataSource()
        }
    }
    
    fileprivate func  configureExclusiveOffersStories(with exclusiveOffersResponse: OffersCategoryResponseModel) {
        
        self.offersListing = exclusiveOffersResponse
        self.offers.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if  !self.offers.isEmpty {
            if let storiesIndex = getSectionIndex(for: .stories) {
                self.dataSource?.dataSources?[storiesIndex] = TableViewDataSource.make(forStories: exclusiveOffersResponse, data: self.smilesExplorerSections?.sectionDetails?[storiesIndex].backgroundColor ?? "#FFFFFF", onClick: { [weak self] story in
                    self?.delegate?.navigateToStoriesWebView(objStory: story)
                })
                self.configureDataSource()
            }
        } else {
            if self.offers.isEmpty {
                self.configureHideSection(for: .stories, dataSource: OffersCategoryResponseModel.self)
            }
        }
        
        
    }
    //MARK: - configure Banner Data
    fileprivate func  configureUpgardeBanner(with sectionsResponse: SectionDetailDO?,index: Int) {
        if let bannerSectionResponse = sectionsResponse, (bannerSectionResponse.backgroundImage != nil) {
            self.dataSource?.dataSources?[index] = TableViewDataSource.make(forUpgradeBanner: bannerSectionResponse, data: "", onClick: { sections in
                debugPrint(sections)
            })
            self.configureDataSource()
        } else {
            self.configureHideSection(for: .upgradeBanner, dataSource: SectionDetailDO.self)
        }
        
    }
    //MARK: - configure Bogo Offer
    fileprivate func configureBogoOffers(with exclusiveOffersResponse: OffersCategoryResponseModel) {
        self.bogooffersListing = exclusiveOffersResponse
        self.bogoOffers.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if !bogoOffers.isEmpty {
            if let offersIndex = getSectionIndex(for: .offerListing) {
                self.dataSource?.dataSources?[offersIndex] = TableViewDataSource.make(forBogoOffers: self.bogoOffers , data: self.smilesExplorerSections?.sectionDetails?[offersIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] isFavorite, offerId, indexPath  in
                    self?.selectedIndexPath = indexPath
                    self?.updateOfferWishlistStatus(isFavorite: isFavorite, offerId: offerId)
                })
                self.configureDataSource()
            }
        } else {
            if self.bogoOffers.isEmpty {
                self.configureHideSection(for: .offerListing, dataSource: OfferDO.self)
            }
        }
    }
    
    //MARK: - configure WishList
    fileprivate func configureWishListData(with updateWishlistResponse: WishListResponseModel) {
        var isFavoriteOffer = false
        if let favoriteIndexPath = self.selectedIndexPath {
            if let updateWishlistStatus = updateWishlistResponse.updateWishlistStatus, updateWishlistStatus {
                isFavoriteOffer = self.offerFavoriteOperation == 1 ? true : false
            } else {
                isFavoriteOffer = false
            }
            (self.dataSource?.dataSources?[favoriteIndexPath.section] as? TableViewDataSource<OfferDO>)?.models?[favoriteIndexPath.row].isWishlisted = isFavoriteOffer
            
            if let cell = tableView.cellForRow(at: favoriteIndexPath) as? RestaurantsRevampTableViewCell {
                cell.offerData?.isWishlisted = isFavoriteOffer
                cell.showFavouriteAnimation(isRestaurant: false)
            }
        }
    }
    
    //MARK: - configure Hide Section
    fileprivate func configureHideSection<T>(for section: SmilesExplorerSubscriptionUpgradeSectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            self.mutatingSectionDetails.removeAll(where: { $0.sectionIdentifier == section.rawValue })
            
            self.configureDataSource()
        }
    }
    //MARK: - configure ShowShimer
    func showShimmer(identifier:SmilesExplorerSubscriptionUpgradeSectionIdentifier){
        if let sectionDetails = self.smilesExplorerSections?.sectionDetails, !sectionDetails.isEmpty {
            for (index, element) in sectionDetails.enumerated() {
                if let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty {
                    if SmilesExplorerSubscriptionUpgradeSectionIdentifier(rawValue: sectionIdentifier) == identifier {
                        switch identifier{
                        case .offerListing:
                            if let response = OfferDO.fromModuleFile() {
                                self.dataSource?.dataSources?[index] = TableViewDataSource.make(forBogoOffers: [response], data:"#FFFFFF", isDummy: true, completion:nil)
                            }
                            break
                        default:break//handle other cases if needed later
                        }
                    }
                }
            }
        }
    }
}

extension SmilesExplorerSubscriptionUpgradeViewController {
    
    //MARK: - Naviagation To Filters
    func redirectToFilters() {
        let selectedFilters = getSelectedFilters()
        if selectedFilters.isEmpty {
            selectedFiltersResponse = nil
        }
        self.delegate?.navigateToFilter(categoryId: viewModel.categoryId ?? 973, sortingType: self.sortingType ?? "", previousFiltersResponse: selectedFiltersResponse, selectedFilters: selectedFilters, filterDelegate: self)
        
    }
    
}

// MARK: - UPDATE USER LOCATION DELEGATE -
extension SmilesExplorerSubscriptionUpgradeViewController: UpdateUserLocationDelegate {
    
    public func userLocationUpdatedSuccessfully() {
        if let isUserSubscribed {
            getSections(isSubscribed: isUserSubscribed, explorerPackageType: subscriptionType ?? .gold, freeTicketAvailed: self.voucherCode != nil ? true:false,platinumLimiReached: platinumLimiReached)
        } else {
            self.input.send(.getRewardPoints)
        }
    }
}

extension SmilesExplorerSubscriptionUpgradeViewController: SelectedFiltersDelegate {
    public func didSetFilters(_ filters: [FilterValue]) {
        arraySelectedSubCategoryTypes.removeAll()
        filtersSavedList = []
        var filterObjects: [RestaurantRequestWithNameFilter] = []
        filters.forEach {
            arraySelectedSubCategoryTypes.append($0.filterKey ?? "")
            let filter = RestaurantRequestWithNameFilter()
            filter.filterName = $0.name
            filter.filterValue = $0.filterKey
            filter.indexPath = $0.indexPath
            filterObjects.append(filter)
        }
        filtersSavedList = filterObjects
        didSelectFilterOrSort = true
        self.viewModel.setFiltersSavedList(filtersSavedList: self.filtersSavedList, filtersList: [])
        self.viewModel.emptyOffers()
        self.showShimmer(identifier: .offerListing)
        self.viewModel.getOffers(tag: .bogoOffers,categoryTypeIdsList: arraySelectedSubCategoryTypes)
    }
    
    public func didSetFilterResponse(_ data: Data?) {
        print("_________didSetFilterResponse is called __________")
        selectedFiltersResponse = data
    }
    
    private func getSelectedFilters() -> [FilterValue] {
        var selectedFilters: [FilterValue] = []
        for item in (filtersSavedList ?? []) {
            var filter = FilterValue()
            filter.indexPath = item.indexPath
            selectedFilters.append(filter)
        }
        return selectedFilters
    }
}

