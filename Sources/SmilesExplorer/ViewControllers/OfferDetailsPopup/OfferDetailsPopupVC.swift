//
//  OfferDetailsPopupVC.swift
//
//
//  Created by Habib Rehman on 15/02/2024.
//

import UIKit
import SmilesUtilities
import Combine
import SmilesOffers

class OfferDetailsPopupVC: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var panView: UIView!
    
    // MARK: - PROPERTIES -
    private let viewModel: OffersDetailViewModel
    private var delegate: SmilesExplorerHomeDelegate? = nil
    var dataSource: SectionedTableViewDataSource?
    lazy var response: OfferDetailsResponse? = nil
    private var cancellables = Set<AnyCancellable>()
    var navC: UINavigationController?
    
    // MARK: - VIEWLIFECYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 2))
        if let response = OfferDetailsResponse.fromModuleFile() {
            self.response = response
            self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersDetailHeader(offers: response, isDummy: true)
            self.dataSource?.dataSources?[1] = TableViewDataSource.makeForOffersDetail(offers: response, isDummy: true)
            self.configureDataSource()
            setDynamicHeightForTableView()
        }
        self.viewModel.getOffers()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.setDynamicHeightForTableView()
    }
    
  
    // MARK: - INITIALIZER -
    init(viewModel: OffersDetailViewModel,delegate:SmilesExplorerHomeDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: "OfferDetailsPopupVC", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUPUI -
    private func setupUI(){
        let dragToDismissGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let tapToDismissGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.panView.addGestureRecognizer(dragToDismissGesture)
        self.panView.addGestureRecognizer(tapToDismissGesture)
        bindStatus()
        setupTableView()
    }
    
    // MARK: - SETUP TABLEVIEW -
    private func setupTableView() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.mainView.layer.cornerRadius = 16.0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        tableView.sectionHeaderHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 22.0))
        tableView.sectionFooterHeight = 0.0
        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.registerCellFromNib(OffersPopupTVC.self, bundle: .module)
        self.tableView.registerCellFromNib(OfferDetailPopupHeaderTVC.self, bundle: .module)
        
    }
    
    // MARK: - ACTIONS -
    @IBAction func onClickActionSubscribeNow(_ sender: Any) {
        self.dismiss {
            SmilesExplorerRouter.shared.pushSubscriptionVC(navVC: self.navC, delegate: self.delegate)
        }
    }
    
    @IBAction func onClickCloseAction(_ sender: Any) {
        self.dismiss()
    }
    
    
}

// MARK: - VIEWMODEL BINDING -
extension OfferDetailsPopupVC {
    
    private func bindStatus() {
        viewModel.offersDetailPublisher.sink { [weak self] state in
            switch state {
            case .fetchOffersDetailDidSucceed(response: let response):
                self?.configureOffers(with: response)
            case .fetchOffersDetailDidFail(error: let error):
                debugPrint(error)
            }
        }
        .store(in: &cancellables)
    }
    
}
// MARK: - OFFERS CONFIGURATIONS -
extension OfferDetailsPopupVC {
    //MARK: - Setting Dynamic Height For TableView
    fileprivate func setDynamicHeightForTableView() {
        let totalHeight = tableView.contentSize.height
        let minHeight = min(totalHeight,self.view.frame.size.height*0.7)
        self.tableViewHeightConst.constant = minHeight
        tableView.isScrollEnabled = totalHeight > minHeight
        view.layoutIfNeeded()
    }
    
    fileprivate func configureDataSource() {
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func configureOffers(with response: OfferDetailsResponse) {
        self.response = response
        self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersDetailHeader(offers: response,isDummy: false)
        self.dataSource?.dataSources?[1] = TableViewDataSource.makeForOffersDetail(offers: response, isDummy: false)
        self.configureDataSource()
        setDynamicHeightForTableView()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
}


extension OfferDetailsPopupVC {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        switch recognizer.state {
        case .changed:
            if translation.y > 0 {
                view.frame.origin.y = translation.y
            }
        case .ended:
            if translation.y > 100 || velocity.y > 500 {
                dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = 0
                }
            }
        default:
            break
        }
    }
}
