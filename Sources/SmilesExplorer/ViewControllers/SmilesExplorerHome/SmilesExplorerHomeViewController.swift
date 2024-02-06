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
        if #available(iOS 15.0, *) {
            contentTableView.sectionHeaderTopPadding = CGFloat(0)
        }
        contentTableView.sectionHeaderHeight = UITableView.automaticDimension
        contentTableView.estimatedSectionHeaderHeight = 1
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
                case .fetchTicketsDidSucceed(let exclusiveOffers):
                    self?.configureTickets(with: exclusiveOffers)
                    break
                case .fetchTicketDidFail(_):
                    self?.configureHideSection(for: .tickets, dataSource: OffersCategoryResponseModel.self)
                    break
                case .fetchSavedFiltersAfterSuccess(_):
//                    self?.filtersSavedList = filtersSavedList
                    break
                case .fetchExclusiveOffersDidSucceed(let exclusiveOffers):
                    self?.configureExclusiveOffers(with: exclusiveOffers)
                    break
                    
                case .fetchExclusiveOffersDidFail( _):
                    self?.configureHideSection(for: .exclusiveDeals, dataSource: OffersCategoryResponseModel.self)
                    break
                    
                case .fetchBogoDidSucceed(let exclusiveOffers):
                    self?.configureBogoOffers(with: exclusiveOffers)
                case .fetchBogoDidFail(_):
                    self?.configureHideSection(for: .bogoOffers, dataSource: OffersCategoryResponseModel.self)
                case .fetchContentForSortingItems(_):
                    //                    self?.sortingListRowModels = baseRowModels
                    break
                case .fetchTopOffersDidSucceed(response: _):
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
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forOffers: response, data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.getTickets(categoryId: self.categoryId, tag: sectionIdentifier, pageNo: 0))
                    break
                case .exclusiveDeals:
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forBogoHomeOffers: response, data: "#FFFFFF", isDummy: true, completion: nil)
                    }
                    self.input.send(.exclusiveDeals(categoryId: self.categoryId, tag: sectionIdentifier, pageNo: 0))
                    break
                case .bogoOffers:
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forBogoHomeOffers: response, data: "#FFFFFF", isDummy: true, completion: nil)
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
        
        if let headerSectionIndex = getSectionIndex(for: .header) {
            dataSource?.dataSources?[headerSectionIndex] = TableViewDataSource.make(header: HomeHeaderResponse(headerImage: "", headerTitle: ""), reuseIdentifier: "HomeHeaderTableViewCell", data: self.smilesExplorerSections?.sectionDetails?[headerSectionIndex].backgroundColor ?? "#FFFFFF", isDummy: false)
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
                    cell.footerconfiguration = self.smilesExplorerSections?.sectionDetails?[footerSectionIndex]
                    cell.setupValues(url: url)
                    cell.getMembership = { [weak self] in
                        // Setup navigation for membership
                        SmilesExplorerRouter.shared.pushSubscriptionVC(navVC: self?.navigationController, delegate: self?.delegate)
                    }
                })
                configureDataSource()
            }
        }else{
                self.configureHideSection(for: .footer, dataSource: SectionDetailDO.self)
        }
        
    }
    
    fileprivate func configureExclusiveOffers(with exclusiveOffersResponse: OffersCategoryResponseModel) {
        self.offersListing = exclusiveOffersResponse
        self.offers.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if !offers.isEmpty, let offerslisting = self.offersListing {
            if let offersCategoryIndex = getSectionIndex(for: .exclusiveDeals) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forBogoHomeOffers: offerslisting, data: self.smilesExplorerSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#FFFFFF", completion: { explorerOffer in
                    print(explorerOffer)
                    
                })
                self.configureDataSource()
            }
        } else {
            if self.offers.isEmpty {
                self.configureHideSection(for: .exclusiveDeals, dataSource: OffersCategoryResponseModel.self)
            }
        }
    }
    
    
    fileprivate func configureTickets(with exclusiveOffersResponse: OffersCategoryResponseModel) {
        self.offersListing = exclusiveOffersResponse
        self.tickets.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if !self.tickets.isEmpty, let offerslisting = self.offersListing {
            if let offersCategoryIndex = getSectionIndex(for: .tickets) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forOffers: offerslisting, data: self.smilesExplorerSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#FFFFFF", completion: { explorerOffer in
                    print(explorerOffer)
                    
                })
                self.configureDataSource()
            }
        } else {
            if self.tickets.isEmpty {
                self.configureHideSection(for: .tickets, dataSource: OffersCategoryResponseModel.self)
            }
        }
    }
    
    
    fileprivate func configureBogoOffers(with exclusiveOffersResponse: OffersCategoryResponseModel) {
        self.offersListing = exclusiveOffersResponse
        self.bogoOffer.append(contentsOf: exclusiveOffersResponse.offers ?? [])
        if !self.bogoOffer.isEmpty , let offerslisting = self.offersListing{
            if let offersCategoryIndex = getSectionIndex(for: .bogoOffers) {
                self.dataSource?.dataSources?[offersCategoryIndex] = TableViewDataSource.make(forBogoHomeOffers: offerslisting, data: self.smilesExplorerSections?.sectionDetails?[offersCategoryIndex].backgroundColor ?? "#FFFFFF", completion: { explorerOffer in
                    print(explorerOffer)
                    
                })
                self.configureDataSource()
            }
        } else {
            if self.bogoOffer.isEmpty {
                self.configureHideSection(for: .bogoOffers, dataSource: OffersCategoryResponseModel.self)
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

