//
//  ExplorerOffersListingViewController.swift
//  
//
//  Created by Abdul Rehman Amjad on 07/02/2024.
//

import UIKit
import SmilesOffers
import SmilesUtilities
import Combine

class ExplorerOffersListingViewController: UIViewController {

    // MARK: - OUTLETS -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var offersTableView: UITableView!
    
    // MARK: - PROPERTIES -
    private lazy var viewModel: SmilesExplorerGetOffersViewModel = {
        return SmilesExplorerGetOffersViewModel()
    }()
    private var input: PassthroughSubject<SmilesExplorerGetOffersViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private var offers = [OfferDO]()
    private var offersTitle: String
    var dataSource: SectionedTableViewDataSource?
    private var offersResponse: OffersCategoryResponseModel
    
    // MARK: - ACTIONS -
    @IBAction func subscribePressed(_ sender: Any) {
    }
    
    // MARK: - INITIALIZERS -
    init(offersResponse: OffersCategoryResponseModel, title: String) {
        self.offersResponse = offersResponse
        self.offersTitle = title
        super.init(nibName: "ExplorerOffersListingViewController", bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - METHODS -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        titleLabel.text = offersTitle
        setUpNavigationBar()
        setupTableView()
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 1))
        configureOffers(with: offersResponse)
    }
    
    private func setupTableView() {
        
        offersTableView.sectionFooterHeight = .leastNormalMagnitude
        offersTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: offersTableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        offersTableView.sectionHeaderHeight = 0.0
        offersTableView.delegate = self
        let explorerOffersListingCellRegistrable: CellRegisterable = ExplorerOffersListingCellRegistration()
        explorerOffersListingCellRegistrable.register(for: offersTableView)
        
    }
    
    private func setUpNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow", in: .module, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnBack.tintColor = .black
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }

    fileprivate func configureDataSource() {
        self.offersTableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.offersTableView.reloadData()
        }
    }
    
}

// MARK: - VIEWMODEL BINDING -
extension ExplorerOffersListingViewController {
    
//    func bind(to viewModel: SmilesExplorerGetOffersViewModel) {
//        input = PassthroughSubject<SmilesExplorerGetOffersViewModel.Input, Never>()
//        let output = viewModel.transform(input: input.eraseToAnyPublisher())
//        output
//            .sink { [weak self] event in
//                switch event {
//                case .fetchExclusiveOffersDidSucceed(let response):
//                    debugPrint(response)
//                    self?.output.send(.fetchExclusiveOffersDidSucceed(response: response))
//                case .fetchExclusiveOffersDidFail(error: let error):
//                    self?.output.send(.fetchExclusiveOffersDidFail(error: error))
//                case .fetchTicketsDidSucceed(response: let response):
//                    self?.output.send(.fetchTicketsDidSucceed(response: response))
//                case .fetchTicketDidFail(error: let error):
//                    self?.output.send(.fetchTicketDidFail(error: error))
//                case .fetchBogoDidSucceed(response: let response):
//                    self?.output.send(.fetchBogoDidSucceed(response: response))
//                case .fetchBogoDidFail(error: let error):
//                    self?.output.send(.fetchBogoDidFail(error: error))
//                }
//            }.store(in: &cancellables)
//    }
    
}

// MARK: - OFFERS CONFIGURATIONS -
extension ExplorerOffersListingViewController {
    
    private func configureOffers(with response: OffersCategoryResponseModel) {
        offersResponse = response
        offers.append(contentsOf: response.offers ?? [])
        if !offers.isEmpty {
            self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersListing(offers: offers)
            self.configureDataSource()
        }
    }
    
}
