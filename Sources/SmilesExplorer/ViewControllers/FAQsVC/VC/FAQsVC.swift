//
//  FAQsVC.swift
//  
//
//  Created by Habib Rehman on 12/02/2024.
//

import UIKit
import Combine
import SmilesUtilities
import SmilesSharedServices
import SmilesReusableComponents

final class FAQsVC: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Properties
    var dataSource: SectionedTableViewDataSource?
    var output: PassthroughSubject<FAQsHomeViewModel.Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    var viewModel: FAQsHomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.getFaqs()
        setUpNavigationBar()
        setupTableView()
    }
    
    public init() {
        super.init(nibName: "FAQsVC", bundle: .module)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - customUI
    fileprivate func setupTableView() {
        self.setUpNavigationBar()
        self.tableView.sectionFooterHeight = .leastNormalMagnitude
        if #available(iOS 15.0, *) {
            self.tableView.sectionHeaderTopPadding = CGFloat(0)
        }
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 1
        tableView.delegate = self
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.registerCellFromNib(FAQTableViewCell.self,bundle: FAQTableViewCell.module)
        self.tableView.backgroundColor = .white
    }
    
    //MARK: - setUpNavigationBar
    private func setUpNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(hexString: "#33424c99")
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let imageView = UIImageView()
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.widthAnchor.constraint(equalToConstant: 24)
        ])
        imageView.tintColor = .black
        imageView.image = UIImage(named: "iconsCategory", in: .module, compatibleWith: nil)
        
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text = "FAQs".localizedString.capitalized
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        let hStack = UIStackView(arrangedSubviews: [imageView, locationNavBarTitle])
        hStack.spacing = 4
        hStack.alignment = .center
        self.navigationItem.titleView = hStack
        let backButton: UIButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow", in: .module, compatibleWith: nil)?.withTintColor(.black), for: .normal)
        backButton.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = backButton.frame.height / 2
        backButton.clipsToBounds = true
        
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    //MARK: Actions
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func configureDataSource() {
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    // MARK: - Navigation


}

// MARK: - DATA BINDING EXTENSION
extension FAQsVC {
    func bind(to viewModel: FAQsHomeViewModel) {
        let output = viewModel.output
        output.sink { [weak self] event in
                switch event {
                case .fetchFAQsDidSucceed(response: let response):
                    self?.configureFAQsDetails(with: response)
                    self?.configureDataSource()
                case .fetchFAQsDidFail(error: let error):
                    debugPrint(error.localizedDescription)
//                    self?.configureHideSection(for: .faq, dataSource: FAQsDetailsResponse.self)
                    
                }
            }.store(in: &cancellables)
    }
    
}

extension FAQsVC {
    // MARK: - configure FAQsDetails
    private func configureFAQsDetails(with response: FAQsDetailsResponse) {
            dataSource?.dataSources?[0] = TableViewDataSource.make(forFAQs: response.faqsDetails ?? [], data: "#FFFFFF", isDummy: false,completion: nil)
            self.configureDataSource()
        
    }
    
}
