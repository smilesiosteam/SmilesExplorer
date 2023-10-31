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



public class SmilesExplorerSubscriptionUpgradeViewController: UIViewController {
    
    @IBOutlet weak var topHeaderView: AppHeaderView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var upgradeNowButton: UIButton!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
  public  var input: PassthroughSubject<SmilesExplorerHomeUpgradeViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerHomeUpgradeViewModel = {
        return SmilesExplorerHomeUpgradeViewModel()
    }()
    
    var dataSource: SectionedTableViewDataSource?
    var sections = [SmilesExplorerSubscriptionUpgradeSectionData]()
    var smilesExplorerSections: GetSectionsResponseModel?
    let categoryId: Int
    private let isGuestUser: Bool
    private var isUserSubscribed: Bool?
    var subscriptionType: ExplorerPackage?
    private var voucherCode: String?
    public var delegate:SmilesExplorerHomeDelegate? = nil
    private var selectedIndexPath: IndexPath?
    var mutatingSectionDetails = [SectionDetailDO]()
    private var offerFavoriteOperation = 0
    
    var selectedLocation: String? = nil
    var isHeaderExpanding = false
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    
    //var categoryId = 0
    public   var offersCategoryId = 0
    public  var sortOfferBy: String?
    public  var sortingType: String?
    public  var lastSortCriteria: String?
    public  var arraySelectedSubCategoryPaths: [IndexPath] = []
    public  var arraySelectedSubCategoryTypes: [String] = []
    
   public var selectedSortTypeIndex: Int?
   public var didSelectFilterOrSort = false
    
    var offersListing: ExplorerOfferResponse?
    var bogooffersListing: OffersCategoryResponseModel?
    var offersPage = 1 // For offers list pagination
    var dodOffersPage = 1 // For DOD offers list pagination
    var offers = [ExplorerOffer]()
    var bogoOffers = [OfferDO]()
    
    public var filtersSavedList: [RestaurantRequestWithNameFilter]?
    public var filtersData: [FiltersCollectionViewCellRevampModel]?
    public var savedFilters: [RestaurantRequestFilter]?
    public var restaurantSortingResponseModel: GetSortingListResponseModel?
    public var selectedSortingTableViewCellModel: FilterDO?
    
    
    private var onFilterClick:(() -> Void)?
    
    
    public var filtersList: [RestaurantRequestFilter]?
    
    public var selectedSort: String?
    private var rewardPoint: Int?
    private var rewardPointIcon: String?
    private var personalizationEventSource: String?
    private var platinumLimiReached: Bool?

    
    var restaurants = [Restaurant]()

    
    public init(categoryId: Int, isGuestUser: Bool, isUserSubscribed: Bool? = nil, subscriptionType: ExplorerPackage? = nil, voucherCode: String? = nil, delegate:SmilesExplorerHomeDelegate, rewardPoint: Int, rewardPointIcon: String,personalizationEventSource: String?,platinumLimiReached: Bool?) {
        self.platinumLimiReached = platinumLimiReached
        self.personalizationEventSource =  personalizationEventSource
        self.categoryId = categoryId
        self.isGuestUser = isGuestUser
        self.isUserSubscribed = isUserSubscribed
        self.subscriptionType = subscriptionType
        self.voucherCode = voucherCode
        self.delegate = delegate
        self.rewardPointIcon = rewardPointIcon
        self.rewardPoint = rewardPoint
        super.init(nibName: "SmilesExplorerSubscriptionUpgradeViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        
        setupTableView()
        bind(to: viewModel)
        
        if let isUserSubscribed {
            getSections(isSubscribed: isUserSubscribed, explorerPackageType: subscriptionType ?? .gold, freeTicketAvailed: self.voucherCode != nil ? true:false,platinumLimiReached: platinumLimiReached)
        } else {
            self.input.send(.getRewardPoints)
        }
        
        selectedLocation = LocationStateSaver.getLocationInfo()?.locationId
        if self.subscriptionType == .platinum || self.platinumLimiReached == true{
            self.upgradeNowButton.isHidden = true
        }else{
            self.upgradeNowButton.isHidden = false
            self.upgradeNowButton.fontTextStyle = .smilesHeadline4
            self.upgradeNowButton.backgroundColor = .appRevampPurpleMainColor
            self.upgradeNowButton.setTitle("Buy Now".localizedString, for: .normal)
        }
        self.setupHeaderView(headerTitle: "")
        let imageName = AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow"
        self.topHeaderView.setCustomImageForBackButton(imageName: imageName)
    }
    
    
    public override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if let currentLocationId = LocationStateSaver.getLocationInfo()?.locationId, let locationId = self.selectedLocation, currentLocationId != locationId {
//            self.input.send(.emptyRestaurantList)
//            self.callFoodOrderServices()
            selectedLocation = LocationStateSaver.getLocationInfo()?.locationId
        }
        
    }
    // MARK: - Helping Functions
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
    
    //MARK: Navigation Bar Setup
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
    
    @objc func onClickBack() {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func onUpgradeBannerButtonClick() {
        SmilesExplorerRouter.shared.showPickTicketPop(viewcontroller: self ,delegate: delegate)
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
    // MARK: - Top Header
    private func setupHeaderView(headerTitle: String?) {
        topHeaderView.delegate = self
        topHeaderView.setupHeaderView(backgroundColor: .white, searchBarColor: .white, pointsViewColor: .black.withAlphaComponent(0.1), titleColor: .black, headerTitle: headerTitle.asStringOrEmpty(), showHeaderNavigaton: true, haveSearchBorder: true, shouldShowBag: false, isGuestUser: isGuestUser, showHeaderContent: isUserSubscribed ?? false, toolTipInfo: nil)
        displayRewardPoints()
    }
    func displayRewardPoints() {
        if let rewardPoints = rewardPoint {
            self.topHeaderView.setPointsOfUser(with: rewardPoints.numberWithCommas())
        }
        
        if let rewardPointsIcon = self.rewardPointIcon {
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
        //showShimmer(identifier: .OFFERLISTING)
        //TODO: Need to send selected filters in below api 
        self.input.send(.getBogoOffers(categoryId: self.categoryId, tag: .exclusiveDealsBogoOffers, pageNo: 1))
       // self.input.send(.getOffersCategoryList(pageNo: 1, categoryId: "\(self.offersCategoryId)", searchByLocation: false, sortingType: sortingType, subCategoryTypeIdsList: arraySelectedSubCategoryTypes))
        
    }
}


// MARK: - APP HEADER DELEGATE -
extension SmilesExplorerSubscriptionUpgradeViewController: AppHeaderDelegate {
    
    public func didTapOnBackButton() {

        navigationController?.popViewController()
        
    }
    
    public func didTapOnSearch() {
        self.delegate?.navigateToGlobalSearch()
       // self.categoryContainerCoordinator?.navigateToGlobalSearchVC()
    }
    
    public func didTapOnLocation() {
        self.delegate?.navigateToLocation()
        //self.categoryContainerCoordinator?.navigateToUpdateLocationVC(confirmLocationRedirection: .toCategoryContainer)
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
       // self.categoryContainerCoordinator?.navigateToTransactionsListViewController(personalizationEventSource: self.personalizationEventSource)
    }
}

extension SmilesExplorerSubscriptionUpgradeViewController {
    // MARK: - Get Sections Api Calls
    private func getSections(isSubscribed: Bool, explorerPackageType: ExplorerPackage,freeTicketAvailed:Bool,platinumLimiReached: Bool? = nil) {
        self.input.send(.getSections(categoryID: categoryId, type: isSubscribed ? "SUBSCRIBED" : "UNSUBSCRIBED", explorerPackageType: explorerPackageType, freeTicketAvailed: freeTicketAvailed,platinumLimiReached: platinumLimiReached))
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
                    
                    if let response = ExplorerOfferResponse.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forStories: response, data:"#FFFFFF", isDummy: true, onClick:nil)
                    }
                    
                    self.input.send(.getExclusiveDealsStories(categoryId: self.categoryId, tag: .exclusiveDealsStories, pageNo: 1))
                    
                    break
                case .offerListing:
                    
                    if let response = OfferDO.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forBogoOffers: [response], data:"#FFFFFF", isDummy: true, completion:nil)
                    }
                    self.input.send(.getBogoOffers(categoryId: self.categoryId, tag: .exclusiveDealsBogoOffers, pageNo: 1))
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
                let imageName = AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow"
                self.topHeaderView.setCustomImageForBackButton(imageName: imageName)
            if self.subscriptionType == .platinum || self.platinumLimiReached == true{
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
        input.send(.updateOfferWishlistStatus(operation: offerFavoriteOperation, offerId: offerId))
    }
}


extension SmilesExplorerSubscriptionUpgradeViewController {
    
    
    // MARK: - Section Data
    
    func bind(to viewModel: SmilesExplorerHomeUpgradeViewModel) {
        input = PassthroughSubject<SmilesExplorerHomeUpgradeViewModel.Input, Never>()
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
                    self?.getSections(isSubscribed: response.explorerSubscriptionStatus ?? false, explorerPackageType: response.explorerPackageType ?? .gold, freeTicketAvailed: response.explorerVoucherCode != nil ? true:false)
                    self?.subscriptionType = response.explorerPackageType
                    self?.voucherCode = response.explorerVoucherCode
                    if response.explorerPackageType ?? .gold == .platinum {
                        self?.upgradeNowButton.isHidden = true
                    }
                    
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    
                case .fetchFiltersDataSuccess(let filters):
                    self?.filtersData = filters
                    break
                case .fetchAllSavedFiltersSuccess(let filtersList, let savedFilters):
                                        self?.savedFilters = filtersList
                                        self?.filtersSavedList = savedFilters
                                        self?.offers.removeAll()
                                        self?.configureDataSource()
                                        self?.configureFiltersData()
                    break
                    
                case .fetchSavedFiltersAfterSuccess(let filtersSavedList):
                    self?.filtersSavedList = filtersSavedList
                    break
                    
                    
                case .fetchContentForSortingItems(_):
                    //                    self?.sortingListRowModels = baseRowModels
                    break
                case .updateWishlistStatusDidSucceed(let updateWishlistResponse):
                    self?.configureWishListData(with: updateWishlistResponse)
                    
                    //                case .updateWishlistStatusDidFail(let error):
                    //                    print(error.localizedDescription)
                    
                    
                case .fetchExclusiveOffersStoriesDidSucceed(let exclusiveOffersStories):
                    self?.configureExclusiveOffersStories(with: exclusiveOffersStories)
                    
                case .fetchExclusiveOffersStoriesDidFail(let error):
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .stories, dataSource: ExplorerOfferResponse.self)
                case .fetchBogoOffersDidSucceed(response: let bogoOffers):
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    self?.configureBogoOffers(with: bogoOffers)
                    
                case .fetchBogoOffersDidFail(error: let error):
                    self?.configureHideSection(for: .offerListing, dataSource: OfferDO.self)
                    debugPrint(error.localizedDescription)
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
    
    fileprivate func  configureExclusiveOffersStories(with exclusiveOffersResponse: ExplorerOfferResponse) {
        
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
                self.configureHideSection(for: .stories, dataSource: ExplorerOfferResponse.self)
            }
        }
        
    
    }
    
    
    fileprivate func  configureUpgardeBanner(with sectionsResponse: SectionDetailDO?,index: Int) {
        
        if let bannerSectionResponse = sectionsResponse, (bannerSectionResponse.backgroundImage != nil) {
            
            self.dataSource?.dataSources?[index] = TableViewDataSource.make(forUpgradeBanner: bannerSectionResponse, data: "", onClick: { sections in
                print(sections)
            })
            self.configureDataSource()
            
        } else {
            self.configureHideSection(for: .upgradeBanner, dataSource: SectionDetailDO.self)
        }
        
        
        
    }
    
    
    fileprivate func configureExclusiveOffers(with exclusiveOffersResponse: ExplorerOfferResponse) {
        self.offersListing = exclusiveOffersResponse
        self.offers.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if !offers.isEmpty {
            if let offersCategoryIndex = getSectionIndex(for: .stories) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forOffers: self.offersListing ?? ExplorerOfferResponse(), data: self.smilesExplorerSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#FFFFFF", completion: { [weak self] explorerOffer in
                    print(explorerOffer)
                    
                })
                self.configureDataSource()
            }
        } else {
            if self.offers.isEmpty {
                self.configureHideSection(for: .offerListing, dataSource: ExplorerOfferResponse.self)
            }
        }
    }
    
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
    
    fileprivate func configureHideSection<T>(for section: SmilesExplorerSubscriptionUpgradeSectionIdentifier, dataSource: T.Type) {
        if let index = getSectionIndex(for: section) {
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.models = []
            (self.dataSource?.dataSources?[index] as? TableViewDataSource<T>)?.isDummy = false
            self.mutatingSectionDetails.removeAll(where: { $0.sectionIdentifier == section.rawValue })
            
            self.configureDataSource()
        }
    }
}

extension SmilesExplorerSubscriptionUpgradeViewController {
    
    func redirectToFilters() {
        
        self.delegate?.navigateToFilter(selectedOfferCategoryIndex: self.categoryId, arraySelectedSubCategoryPAths: self.arraySelectedSubCategoryPaths, sortingType: self.sortingType ?? "")
      //  SmilesExplorerRouter.shared.pushSmilesExplorerOffersFiltersVC(navVC: self.navigationController, delegate: self.delegate)
        
    }
    
    func redirectToSortingVC(){
        
        SmilesExplorerRouter.shared.pushSmilesExplorerSortingVC(navVC: self.navigationController!)
    }
    
    
}

