//
//  FAQsViewController.swift
//
//
//  Created by Habib Rehman on 12/02/2024.
//

import UIKit
import Combine
import SmilesUtilities
import SmilesSharedServices
import SmilesReusableComponents

final class FAQsViewController: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - PROPERTIES -
    var dataSource: SectionedTableViewDataSource?
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: ExplorerFAQsViewModel
    
    // MARK: - METHODS -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    init(viewModel: ExplorerFAQsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "FAQsViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        setUpNavigationBar()
        setupTableView()
        bindStatus()
        setupFAQs()
        
    }
    
    fileprivate func setupTableView() {
        tableView.sectionFooterHeight = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        tableView.sectionHeaderHeight = 0.0
        tableView.delegate = self
        tableView.registerCellFromNib(FAQTableViewCell.self, bundle: FAQTableViewCell.module)
    }
    
    private func setUpNavigationBar() {
        
        navigationItem.title = "FAQs".localizedString
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
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func setupFAQs() {
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 1))
        if let response = FAQsDetailsResponse.fromModuleFile() {
            self.dataSource?.dataSources?[0] = TableViewDataSource.make(forFAQs: response.faqsDetails ?? [], data: "#FFFFFF", isDummy: true)
            configureDataSource()
        }
        viewModel.getFaqs()
    }
    
}

// MARK: - DATA BINDING EXTENSION
extension FAQsViewController {
    
    private func bindStatus() {
        viewModel.faqsPublisher.sink { [weak self] state in
            switch state {
            case .fetchFAQsDidSucceed(response: let response):
                self?.configureFAQsDetails(with: response)
            case .fetchFAQsDidFail(error: let error):
                debugPrint(error.localizedDescription)
            }
        }.store(in: &cancellables)
    }
    
}

extension FAQsViewController {
    // MARK: - configure FAQsDetails
    private func configureFAQsDetails(with response: FAQsDetailsResponse) {
        dataSource?.dataSources?[0] = TableViewDataSource.make(forFAQs: response.faqsDetails ?? [], data: "#FFFFFF", isDummy: false)
        self.configureDataSource()
    }
    
}
