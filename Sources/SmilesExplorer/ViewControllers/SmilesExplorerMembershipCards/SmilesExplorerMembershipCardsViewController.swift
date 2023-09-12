//
//  SmilesExplorerMembershipCardsViewController.swift
//  
//
//  Created by Habib Rehman on 17/08/2023.
//

import UIKit
import SmilesLanguageManager
import SmilesUtilities
import Combine
import SmilesLoader


class SmilesExplorerMembershipCardsViewController: UIViewController {
    
    //MARK: Properties
    var dataSource: SectionedTableViewDataSource?
    
    var membershipPicked:BOGODetailsResponseLifestyleOffer?
    var response: SmilesExplorerSubscriptionInfoResponse?
    private var input: PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerMembershipSelectionViewModel = {
        return SmilesExplorerMembershipSelectionViewModel()
    }()
    public var delegate: SmilesExplorerHomeDelegate?
    
    //MARK: IBoutlet
    @IBOutlet weak var smilesExplorerLabel: UILabel!
    @IBOutlet weak var pickPassTypeLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var continueButtonView: UIView!{
        didSet{
            continueButtonView.layer.cornerRadius = 32.0
        }
    }
    
    init() {
        super.init(nibName: "SmilesExplorerMembershipCardsViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VIEW LIFECYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        SmilesLoader.show(on: self.view)
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func setupViews() {
        
        setupTableView()
        bind(to: viewModel)
        input.send(.getSubscriptionInfo)
        
    }
    
    private func setupTableView() {
        
        tableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = CGFloat(0)
        }
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        
        tableView.delegate = self
        //        tableView.dataSource = self
        let smilesExplorerCellRegistrable: CellRegisterable = SmilesExplorerSubscriptionCellRegistration()
        smilesExplorerCellRegistrable.register(for: tableView)
        
    }
    
    fileprivate func configureDataSource() {
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
        imageView.sd_setImage(with: URL(string: response?.themeResources?.explorerTopPlaceholderIcon ?? "")) { image, _, _, _ in
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
        }
        
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = response?.themeResources?.explorerTopPlaceholderTitle ?? "Smiles Explorer"
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_icon_ar" : "back_Icon", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        btnBack.layer.cornerRadius = btnBack.frame.height / 2
        btnBack.clipsToBounds = true
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    //MARK: Actions
    @IBAction func membershipSelectPressed(_ sender: UIButton) {
        
        guard let membership = self.membershipPicked else { return }
        let objSmilesExplorerPaymentParams = SmilesExplorerPaymentParams(lifeStyleOffer: membership, isComingFromSpecialOffer: false, isComingFromTreasureChest: false)
        delegate?.proceedToPayment(params: objSmilesExplorerPaymentParams, navigationType: .payment)
    }
    
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

// MARK: - VIEWMODEL BINDING -
extension SmilesExplorerMembershipCardsViewController {
    
    func bind(to viewModel: SmilesExplorerMembershipSelectionViewModel) {
        input = PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSubscriptionInfoDidSucceed(response: let response):
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    self?.configureSmilesExplorerSubscriptions(with: response)
                    self?.response = response
                case .fetchSubscriptionInfoDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - TABLEVIEW DATASOURCE CONFIGURATION -

extension SmilesExplorerMembershipCardsViewController {
    
    private func configureSmilesExplorerSubscriptions(with response: SmilesExplorerSubscriptionInfoResponse) {
        self.pickPassTypeLabel.text = response.themeResources?.explorerSubscriptionTitle ?? ""
        self.smilesExplorerLabel.text = response.themeResources?.explorerSubscriptionSubTitle ?? ""
        self.response = response
        self.setUpNavigationBar()
        if let offers = response.lifestyleOffers {
            let dataSource = TableViewDataSource.make(forSubscriptions: offers, data: "#FFFFFF")
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 1))
            self.dataSource?.dataSources?[0] = dataSource
            self.configureDataSource()
        }
    }
    
}

