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
    @IBOutlet weak var contentTableView: UITableView!
    
    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var  input: PassthroughSubject<SmilesExplorerHomeViewModel.Input, Never> = .init()
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
    var offersListing: OffersCategoryResponseModel?
    var offersPage = 1 // For offers list pagination
    var dodOffersPage = 1 // For DOD offers list pagination
    var offers = [OfferDO]()
    var tickets = [OfferDO]()
    var bogoOffer = [OfferDO]()
    var dodOffers = [OfferDO]()
    private var selectedIndexPath: IndexPath?
    var categoryDetailsSections: GetSectionsResponseModel?
    var mutatingSectionDetails = [SectionDetailDO]()
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
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
        //        if let isUserSubscribed {
        getSections(isSubscribed: false)
        //        } else {
        //            self.input.send(.getRewardPoints)
        //        }
        
    }
    
    private func setupTableView() {
        
        contentTableView.sectionFooterHeight = .leastNormalMagnitude
        contentTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: contentTableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        contentTableView.sectionHeaderHeight = 0.0
        contentTableView.delegate = self
        let smilesExplorerCellRegistrable: CellRegisterable = SmilesExplorerHomeCellRegistration()
        smilesExplorerCellRegistrable.register(for: contentTableView)
        
    }
    
    fileprivate func configureDataSource() {
        self.contentTableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.contentTableView.reloadData()
        }
    }
    
    private func configureSectionsData(with sectionsResponse: GetSectionsResponseModel) {
        
        smilesExplorerSections = sectionsResponse
        setUpNavigationBar()
        if let sectionDetailsArray = sectionsResponse.sectionDetails, !sectionDetailsArray.isEmpty {
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: sectionDetailsArray.count))
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
    
    private func setUpNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hex: "ECEDF5")
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        guard let headerData = smilesExplorerSections?.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSectionIdentifier.topPlaceholder.rawValue }) else { return }
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.tintColor = .black
        imageView.sd_setImage(with: URL(string: headerData.iconUrl ?? "")) { image, _, _, _ in
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }

        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = headerData.title
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = .white
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_icon_ar" : "back_icon", in: .module, with: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.clipsToBounds = true
        btnBack.tintColor = .black
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
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
                    self?.configureHideSection(for: .footer, dataSource: SectionDetailDO.self)
//                    self?.configureHideSection(for: .header, dataSource: SectionDetailDO.self)
                case .fetchRewardPointsDidSucceed(response: let response, _):
                    self?.isUserSubscribed = response.explorerSubscriptionStatus
                    self?.getSections(isSubscribed: response.explorerSubscriptionStatus ?? false)
                    self?.subscriptionType = response.explorerPackageType
                    self?.voucherCode = response.explorerVoucherCode
                    
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    
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
                case .fetchTicketsDidSucceed(let offers):
                    self?.configureOffers(with: offers, section: .tickets)
                case .fetchTicketDidFail(_):
                    self?.configureHideSection(for: .tickets, dataSource: OffersCategoryResponseModel.self)
                    break
                case .fetchSavedFiltersAfterSuccess(_):
//                    self?.filtersSavedList = filtersSavedList
                    break
                case .fetchExclusiveOffersDidSucceed(let offers):
                    self?.configureOffers(with: offers, section: .exclusiveDeals)
                    
                case .fetchExclusiveOffersDidFail( _):
                    self?.configureHideSection(for: .exclusiveDeals, dataSource: OffersCategoryResponseModel.self)
                    break
                    
                case .fetchBogoDidSucceed(let offers):
                    self?.configureOffers(with: offers, section: .bogoOffers)
                case .fetchBogoDidFail(_):
                    self?.configureHideSection(for: .bogoOffers, dataSource: OffersCategoryResponseModel.self)
                case .fetchContentForSortingItems(_):
                    //                    self?.sortingListRowModels = baseRowModels
                    break
                case .fetchTopOffersDidSucceed(response: _):
                    break
                    
                case .fetchSubscriptionBannerDetailsDidSucceed(let response):
                    self?.configureFooterSection(with: response)
                    
                case .fetchSubscriptionBannerDetailsDidFail(_):
                    self?.configureHideSection(for: .footer, dataSource: SectionDetailDO.self)
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
                    if let response = ExplorerSubscriptionBannerResponse.fromModuleFile(), let footer = response.footer {
                        let title = smilesExplorerSections?.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSectionIdentifier.topPlaceholder.rawValue })?.title
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(footer: footer, title: title, data: element.backgroundColor ?? "FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getSubscriptionBannerDetails)
                case .tickets:
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forOffers: response, data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getTickets(categoryId: self.categoryId, tag: sectionIdentifier, pageNo: 0))
                    break
                case .exclusiveDeals:
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forOffers: response, data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.exclusiveDeals(categoryId: self.categoryId, tag: sectionIdentifier, pageNo: 0))
                    break
                case .bogoOffers:
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forOffers: response, data: "#FFFFFF", isDummy: true, completion: nil)
                    }
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
        
        if let headerSectionIndex = getSectionIndex(for: .header), let sectionData = smilesExplorerSections?.sectionDetails?[headerSectionIndex] {
            dataSource?.dataSources?[headerSectionIndex] = TableViewDataSource.make(header: HomeHeaderResponse(headerImage: sectionData.backgroundImage, headerTitle: sectionData.title), data: self.smilesExplorerSections?.sectionDetails?[headerSectionIndex].backgroundColor ?? "#FFFFFF", isDummy: false)
            configureDataSource()
        }
        
    }
    
    private func configureFooterSection(with response: ExplorerSubscriptionBannerResponse) {
        
        if let footer = response.footer, let footerSectionIndex = getSectionIndex(for: .footer), let sectionDetails = self.smilesExplorerSections?.sectionDetails?[footerSectionIndex] {
            self.dataSource?.dataSources?[footerSectionIndex] = TableViewDataSource.make(footer: footer, title: sectionDetails.title, data: sectionDetails.backgroundColor ?? "FFFFFF", 
                                                                                         completion: { [weak self] in
                SmilesExplorerRouter.shared.pushSubscriptionVC(navVC: self?.navigationController, delegate: self?.delegate)
            })
        } else {
            self.configureHideSection(for: .footer, dataSource: SectionDetailDO.self)
        }
        
    }
    
    fileprivate func configureOffers(with response: OffersCategoryResponseModel, section: SmilesExplorerSectionIdentifier) {
        self.offersListing = response
        var offers = [OfferDO]()
        switch section {
        case .tickets:
            offers = tickets
        case .exclusiveDeals:
            offers = self.offers
        case .bogoOffers:
            offers = bogoOffer
        default: break
        }
        offers.append(contentsOf: response.offers ?? [])
        if !offers.isEmpty, let offerslisting = self.offersListing {
            if let offersIndex = getSectionIndex(for: section), let sectionDetails = self.smilesExplorerSections?.sectionDetails?[offersIndex] {
                self.dataSource?.dataSources?[offersIndex] = TableViewDataSource.make(forOffers: offerslisting, data: sectionDetails.backgroundColor ?? "#FFFFFF", title: sectionDetails.title, subtitle: sectionDetails.subTitle, offersImage: sectionDetails.iconUrl, isForTickets: section == .tickets, completion: { explorerOffer in
                    
                })
                self.configureDataSource()
            }
        } else {
            if offers.isEmpty {
                self.configureHideSection(for: section, dataSource: OffersCategoryResponseModel.self)
            }
        }
    }
    

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

