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

class SmilesExplorerMembershipCardsViewController: UIViewController {
    
    //MARK: Properties
    private var dataSource: SectionedTableViewDataSource?
    private var response: SmilesExplorerSubscriptionInfoResponse?
    private var input: PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerMembershipSelectionViewModel = {
        return SmilesExplorerMembershipSelectionViewModel()
    }()
    
    //MARK: IBoutlet
    @IBOutlet var smilesExplorerLabel: UILabel!
    @IBOutlet var pickPassTypeLabel: UILabel!
    
    
    @IBOutlet var membershipTableView: UITableView!
    
    
    
    // MARK: - VIEW LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
       
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBar()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    private func setupViews() {
        
        setupTableView()
        bind(to: viewModel)
        input.send(.getSubscriptionInfo)
        
    }
    
    private func setupTableView() {
        membershipTableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            membershipTableView.sectionHeaderTopPadding = CGFloat(0)
        }
        membershipTableView.sectionHeaderHeight = UITableView.automaticDimension
        membershipTableView.estimatedSectionHeaderHeight = 1
//        membershipTableView.delegate = self
        let manCityCellRegistrable: CellRegisterable = SmilesExplorerHomeCellRegistration()
        manCityCellRegistrable.register(for: membershipTableView)
        
    }
    
    fileprivate func configureDataSource() {
        self.membershipTableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.membershipTableView.reloadData()
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
        locationNavBarTitle.text = response?.themeResources?.explorerTopPlaceholderTitle
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack

        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_icon_ar" : "back_icon", in: .module, compatibleWith: nil), for: .normal)
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
                    self?.configureSmilesExplorerSubscriptions(with: response)
                    
                case .fetchSubscriptionInfoDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                default: break
                }
            }.store(in: &cancellables)
    }
    
}

// MARK: - TABLEVIEW DATASOURCE CONFIGURATION -

extension SmilesExplorerMembershipCardsViewController {
    
    private func configureSmilesExplorerSubscriptions(with response: SmilesExplorerSubscriptionInfoResponse) {
        self.pickPassTypeLabel.text = response.themeResources?.explorerSubscriptionTitle ?? ""
        self.smilesExplorerLabel.text = response.themeResources?.explorerSubscriptionSubTitle ?? ""
        self.setUpNavigationBar()
        if let offers = response.lifestyleOffers {
            let dataSource = TableViewDataSource.make(forSubscriptions: offers, data: "#FFFFFF")
            self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 1))
            self.dataSource?.dataSources?[0] = dataSource
            self.configureDataSource()
        }
    }
    
}
