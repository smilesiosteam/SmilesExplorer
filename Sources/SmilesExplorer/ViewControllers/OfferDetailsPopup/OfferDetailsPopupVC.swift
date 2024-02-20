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
        response = nil
        setupUI()
        self.dataSource = SectionedTableViewDataSource(dataSources: Array(repeating: [], count: 1))
        if let response = OfferDetailsResponse.fromModuleFile() {
            self.response = response
            self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersDetail(offers: response, isDummy: true)
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.panView.addGestureRecognizer(panGesture)
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
        tableView.allowsSelection = false
        tableView.registerCellFromNib(OffersPopupTVC.self, bundle: .module)
        
        
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
    fileprivate func setDynamicHeightForTableView(response:OfferDetailsResponse) {
        let minHeight = min(view.bounds.height - view.safeAreaInsets.top - 360, (CGFloat(response.whatYouGetList?.count ?? 0) * 30.0)+60)
        tableViewHeightConst.constant = minHeight
        tableView.isScrollEnabled = minHeight > (view.bounds.height - 360)
    }
    
    private func configureOffers(with response: OfferDetailsResponse) {
        self.response = response
        setDynamicHeightForTableView(response:response)
        self.imgOfferDetail.setImageWithUrlString(viewModel.imageURL ?? "")
        self.dataSource?.dataSources?[0] = TableViewDataSource.makeForOffersDetail(offers: response,isDummy: false)
        self.showHide(isDummy: false, view: imgOfferDetail)
        self.configureDataSource()
    }
    
}


extension OfferDetailsPopupVC {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
          let translation = recognizer.translation(in: view)
          let velocity = recognizer.velocity(in: view)
          
          switch recognizer.state {
          case .changed:
              if translation.y > 0 {
                  // Move the view with the user's gesture
                  view.frame.origin.y = translation.y
              }
          case .ended:
              if translation.y > 100 || velocity.y > 500 {
                  // Dismiss the view controller if the gesture is fast or the translation is significant
                  dismiss(animated: true, completion: nil)
              } else {
                  // Return the view to its original position if the gesture is not enough to dismiss
                  UIView.animate(withDuration: 0.3) {
                      self.view.frame.origin.y = 0
                  }
              }
          default:
              break
          }
      }
}
