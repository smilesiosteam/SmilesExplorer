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
    let viewModel: ExplorerOffersListingViewModel
    var dataSource: SectionedTableViewDataSource?
    var dependencies: ExplorerOffersListingDependance
    var offers = [OfferDO]()
    var offersPage = 1
    private var cancellables = Set<AnyCancellable>()
    public weak var delegate: SmilesExplorerHomeDelegate? = nil
    
    
    // MARK: - INITIALIZERS -
    init(viewModel: ExplorerOffersListingViewModel, dependencies: ExplorerOffersListingDependance) {
        self.viewModel = viewModel
        self.dependencies = dependencies
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    private func setupViews() {
        bindStatus()
        titleLabel.text = dependencies.title
        setUpNavigationBar()
        setupTableView()
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 1))
        configureOffers(with: dependencies.offersResponse)
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
    
    // MARK: - ACTIONS -
    @IBAction func onClickSubscription(_ sender: Any) {
        
        SmilesExplorerRouter.shared.pushSubscriptionVC(navVC: self.navigationController, delegate: self.delegate)
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
    
    private func bindStatus() {
        viewModel.offersListingPublisher.sink { [weak self] state in
            switch state {
            case .fetchOffersDidSucceed(response: let response):
                self?.configureOffers(with: response)
            case .offersDidFail(error: let error):
                debugPrint(error)
            }
        }
        .store(in: &cancellables)
    }
    
}

// MARK: - OFFERS CONFIGURATIONS -
extension ExplorerOffersListingViewController {
    
    private func configureOffers(with response: OffersCategoryResponseModel) {
        offersTableView.tableFooterView = nil
        dependencies.offersResponse = response
        offers.append(contentsOf: response.offers ?? [])
        if !offers.isEmpty {
            self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersListing(offers: offers)
            self.configureDataSource()
        }
    }
    
}
