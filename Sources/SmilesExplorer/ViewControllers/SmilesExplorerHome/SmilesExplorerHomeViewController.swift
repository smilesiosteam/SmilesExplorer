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
import NetworkingLayer

public class SmilesExplorerHomeViewController: UIViewController, SmilesPresentableMessage {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var contentTableView: UITableView!
    
    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var cancellables = Set<AnyCancellable>()
    var smilesExplorerSections: GetSectionsResponseModel?
    var sections = [SmilesExplorerSectionData]()
    
    private var viewModel: SmilesTouristHomeViewModel!
    public weak var delegate: SmilesExplorerHomeDelegate? = nil
    var ticketsResponse: OffersCategoryResponseModel?
    var exclusiveDealsResponse: OffersCategoryResponseModel?
    var bogoOffersResponse: OffersCategoryResponseModel?
    var offersPage = 1 // For offers list pagination
    var dodOffersPage = 1 // For DOD offers list pagination
    var offers = [OfferDO]()
    var tickets = [OfferDO]()
    var bogoOffer = [OfferDO]()
    private var selectedIndexPath: IndexPath?
    var categoryDetailsSections: GetSectionsResponseModel?
    var mutatingSectionDetails = [SectionDetailDO]()
    
    // MARK: - ACTIONS -
    @IBAction func getMembershipPressed(_ sender: Any) {
        SmilesExplorerRouter.shared.pushSubscriptionVC(navVC: navigationController, delegate: delegate)
    }
    
    // MARK: - METHODS -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.getSections()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
     init(viewModel:SmilesTouristHomeViewModel,delegate:SmilesExplorerHomeDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: "SmilesExplorerHomeViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        setupTableView()
        bind(to: viewModel)
    }
    
    private func setupTableView() {
        
        contentTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: contentTableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        contentTableView.sectionHeaderHeight = 0.0
        contentTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: contentTableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        contentTableView.sectionFooterHeight = 0.0
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
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        let headerData = smilesExplorerSections?.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSectionIdentifier.topPlaceholder.rawValue })
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.tintColor = .black
        imageView.sd_setImage(with: URL(string: headerData?.iconUrl ?? "")) { image, _, _, _ in
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }

        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = headerData?.title
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
    
    func bind(to viewModel: SmilesTouristHomeViewModel) {
        let output = viewModel.output
        output
            .sink { [weak self] event in
                switch event {
                    
                case .fetchSectionsDidSucceed(let sectionsResponse):
                    self?.configureSectionsData(with: sectionsResponse)
                case .fetchSectionsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    self?.configureHideSection(for: .footer, dataSource: SectionDetailDO.self)
                    self?.configureHideSection(for: .header, dataSource: SectionDetailDO.self)
                    if case NetworkError.networkNotReachable(_) = error {
                        self?.showMessage(model: SmilesMessageModel(image: UIImage(named: "noSignal"), title: "No signal".localizedString, description: "NoInternetConnection".localizedString, presentationType: .fullScreen, showForRetry: true), delegate: self)
                    }
                    
                case .fetchRewardPointsDidSucceed(response: let response, _):
                    self?.viewModel.isUserSubscribed = response.explorerSubscriptionStatus
                    self?.viewModel.subscriptionType = response.explorerPackageType
                    self?.viewModel.voucherCode = response.explorerVoucherCode
                case .fetchRewardPointsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                 
                case .fetchTicketsDidSucceed(let offers):
                    self?.configureOffers(with: offers, section: .tickets)
                case .fetchTicketDidFail(_):
                    self?.configureHideSection(for: .tickets, dataSource: OffersCategoryResponseModel.self)
                    
                case .fetchExclusiveOffersDidSucceed(let offers):
                    self?.configureOffers(with: offers, section: .exclusiveDeals)
                case .fetchExclusiveOffersDidFail( _):
                    self?.configureHideSection(for: .exclusiveDeals, dataSource: OffersCategoryResponseModel.self)
                    
                case .fetchBogoOffersDidSucceed(let offers):
                    self?.configureOffers(with: offers, section: .bogoOffers)
                case .fetchBogoOffersDidFail(_):
                    self?.configureHideSection(for: .bogoOffers, dataSource: OffersCategoryResponseModel.self)

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
    
    private func homeAPICalls() {
        
        if let sectionDetails = self.smilesExplorerSections?.sectionDetails, !sectionDetails.isEmpty {
            sections.removeAll()
            for (index, element) in sectionDetails.enumerated() {
                guard let sectionIdentifier = element.sectionIdentifier, !sectionIdentifier.isEmpty else {
                    return
                }
                guard let section = SmilesExplorerSectionIdentifier(rawValue: sectionIdentifier) else { return }
                if section != .topPlaceholder {
                    sections.append(SmilesExplorerSectionData(index: index, identifier: section))
                }
                switch section {
                case .header:
                    configureHeaderSection()
                case .footer:
                    if let response = ExplorerSubscriptionBannerResponse.fromModuleFile(), let footer = response.footer {
                        let title = smilesExplorerSections?.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSectionIdentifier.topPlaceholder.rawValue })?.title
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(footer: footer, title: title, data: element.backgroundColor ?? "FFFFFF", isDummy: true)
                    }
                    viewModel.getSubscriptionBannerDetails()
                case .tickets, .exclusiveDeals, .bogoOffers:
                    if let response = OffersCategoryResponseModel.fromModuleFile() {
                        self.dataSource?.dataSources?[index] = TableViewDataSource.make(forOffers: response.offers ?? [], data: "FFFFFF", isDummy: true, title: element.title, subtitle: element.subTitle, offersIcon: response.iconImageUrl, section: section)
                    }
                    self.viewModel.getOffers(tag: SectionTypeTag(rawValue: section.rawValue) ?? .tickets)
                case .topPlaceholder:
                    break
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
        
        if let footer = response.footer, let footerSectionIndex = getSectionIndex(for: .footer) {
            let topPlaceholder = smilesExplorerSections?.sectionDetails?.first(where: { $0.sectionIdentifier == SmilesExplorerSectionIdentifier.topPlaceholder.rawValue })
            self.dataSource?.dataSources?[footerSectionIndex] = TableViewDataSource.make(footer: footer, title: topPlaceholder?.title, data: "FFFFFF", delegate: self)
        } else {
            self.configureHideSection(for: .footer, dataSource: SectionDetailDO.self)
        }
        
    }
    
    fileprivate func configureOffers(with response: OffersCategoryResponseModel, section: SmilesExplorerSectionIdentifier) {
        var offers = [OfferDO]()
        switch section {
        case .tickets:
            offers = tickets
            ticketsResponse = response
        case .exclusiveDeals:
            offers = self.offers
            exclusiveDealsResponse = response
        case .bogoOffers:
            offers = bogoOffer
            bogoOffersResponse = response
        default: break
        }
        offers.append(contentsOf: response.offers ?? [])
        if !offers.isEmpty {
            if let offersIndex = getSectionIndex(for: section),
               let sectionDetails = self.smilesExplorerSections?.sectionDetails?[offersIndex] {
                self.dataSource?.dataSources?[offersIndex] = TableViewDataSource.make(forOffers: offers, data: sectionDetails.backgroundColor ?? "#FFFFFF", title: sectionDetails.title, subtitle: sectionDetails.subTitle, offersIcon: response.iconImageUrl, section: section, delegate: self)
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

// MARK: - HOME OFFERS DELEGATE -
extension SmilesExplorerHomeViewController: HomeOffersDelegate {
    
    func showOfferDetails(offer: OfferDO) {
        SmilesExplorerRouter.shared.showOfferDetailPopup(viewcontroller: self, dependence: offer, delegate: delegate)
    }
    
    func showOffersList(section: SmilesExplorerSectionIdentifier) {
        var response: OffersCategoryResponseModel?
        switch section {
        case .tickets:
            response = ticketsResponse
        case .exclusiveDeals:
            response = exclusiveDealsResponse
        case .bogoOffers:
            response = bogoOffersResponse
        default: break
        }
        guard let response, let offersIndex = getSectionIndex(for: section),
                                let sectionDetails = self.smilesExplorerSections?.sectionDetails?[offersIndex] else { return }
        let dependence = ExplorerOffersListingDependance(categoryId: viewModel.categoryId ?? ExplorerConstants.explorerCategoryID, title: sectionDetails.title ?? "", offersResponse: response, offersTag: SectionTypeTag(rawValue: section.rawValue) ?? .tickets)
        SmilesExplorerRouter.shared.pushOffersListingVC(navVC: navigationController, dependence: dependence,delegate: delegate)
    }
    
}

// MARK: - HOME FOOTER DELEGATE -
extension SmilesExplorerHomeViewController: ExplorerHomeFooterDelegate {
    
    func faqsPressed() {
        SmilesExplorerRouter.shared.pushFAQsVC(navVC: navigationController)
    }
    
}

// MARK: - MESSAGE VIEW DELEGATE -
extension SmilesExplorerHomeViewController: SmilesMessageViewDelegate {
    
    public func primaryButtonPressed(isForRetry: Bool) {
        viewModel.getSections()
    }
    
}
