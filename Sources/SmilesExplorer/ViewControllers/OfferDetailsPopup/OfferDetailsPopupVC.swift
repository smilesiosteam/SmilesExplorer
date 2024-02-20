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
    @IBOutlet weak var imgOfferDetail: UIImageView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tableViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConst: NSLayoutConstraint!
    
    // MARK: - PROPERTIES -
    private let viewModel:OffersDetailViewModel
    var delegate:SmilesExplorerHomeDelegate? = nil
    public var imageURL: String?
    var dataSource: SectionedTableViewDataSource?
    lazy var response: OfferDetailsResponse? = nil
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - VIEWLIFECYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        response = nil
        setupUI()
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 1))
        if let response = OfferDetailsResponse.fromModuleFile() {
            self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersDetail(offers: response, isDummy: true)
            self.response = response
            self.configureDataSource()
        }
        showHide(isDummy: true, view: self.imgOfferDetail)
        self.viewModel.getOffers()
        
    }
    // MARK: - Confgiure Shimmer For HeaderView
    func showHide(isDummy: Bool,view: UIView) {
        if isDummy {
            view.enableSkeleton()
            view.showAnimatedGradientSkeleton()
        } else {
            view.hideSkeleton()
        }
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
        bindStatus()
        setupTableView()
    }
    
    // MARK: - SETUP TABLEVIEW -
    private func setupTableView() {
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.mainView.layer.cornerRadius = 16.0
        self.imgOfferDetail.layer.cornerRadius = 16.0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        tableView.sectionHeaderHeight = 0.0
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: CGFloat.leastNormalMagnitude))
        tableView.sectionFooterHeight = 0.0
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.registerCellFromNib(OffersPopupTVC.self, bundle: .module)
        
        
    }
    
    // MARK: - ACTIONS -
    @IBAction func onClickActionSubscribeNow(_ sender: Any) {
        
    }
    
    @IBAction func onClickCloseAction(_ sender: Any) {
        self.dismiss()
    }
    
    fileprivate func configureDataSource() {
        self.tableView.dataSource = self.dataSource
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// MARK: - VIEWMODEL BINDING -
extension OfferDetailsPopupVC {
    
    private func bindStatus() {
        viewModel.offersDetailPublisher.sink { [weak self] state in
            switch state {
            case .fetchOffersDetailDidSucceed(response: let response):
                self?.configureOffers(with: response)
                self?.response = response
            case .fetchOffersDetailDidFail(error: let error):
                debugPrint(error)
            }
        }
        .store(in: &cancellables)
    }
    
}
// MARK: - OFFERS CONFIGURATIONS -
extension OfferDetailsPopupVC {
    
    private func configureOffers(with response: OfferDetailsResponse) {
        print(response.whatYouGetList ?? [])
        let tableHeight = CGFloat(response.whatYouGetList?.count ?? 0) * 30.0
        if tableHeight < UIScreen.main.bounds.height-tableHeight+60 {
            self.tableViewHeightConst.constant = tableHeight+60
        }else{
            self.tableViewHeightConst.constant = UIScreen.main.bounds.height-tableHeight+60
        }
        self.imgOfferDetail.setImageWithUrlString(self.imageURL ?? "")
        self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersDetail(offers: response,isDummy: false)
        self.showHide(isDummy: false, view: imgOfferDetail)
        if self.imgOfferDetail.image == nil {
            self.imgHeightConst.constant = 0
        }
        self.configureDataSource()
    }
    
}

