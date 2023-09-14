//
//  SmilesExplorerPickTicketPopUp.swift
//  
//
//  Created by Ghullam  Abbas on 23/08/2023.
//

import UIKit
import SmilesUtilities
import Combine
import LottieAnimationManager
import SmilesLanguageManager
import SmilesFontsManager
import SmilesLoader
import SmilesOffers

public class SmilesExplorerPickTicketPopUp: UIViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var ticketsCollectionView: UICollectionView!
    @IBOutlet weak var upgradeButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    //MARK: - Properties -
    private var input: PassthroughSubject<SmilesExplorerPickTicketViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerPickTicketViewModel = {
        return SmilesExplorerPickTicketViewModel()
    }()
    private var response:OffersCategoryResponseModel?
     var paymentDelegate: SmilesExplorerHomeDelegate?

    var currentPage = 1
    var isLoading = false
    var hasMoreData = true
    
    
    //
    private var responseMemberShip: SmilesExplorerSubscriptionInfoResponse?
    private var inputMemberShip: PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never> = .init()
    private lazy var viewModelMenberShip: SmilesExplorerMembershipSelectionViewModel = {
        return SmilesExplorerMembershipSelectionViewModel()
    }()
    
    //MARK: - View Controller Lifecycle -
    public override func viewDidLoad() {
        super.viewDidLoad()
        styleFontAndTextColor()
        setupUI()
        self.bindMemberShip(to: self.viewModelMenberShip)
        self.bind(to: viewModel)
        self.inputMemberShip.send(.getSubscriptionInfo("platinum"))
        // Do any additional setup after loading the view.
    }
    override public func viewWillAppear(_ animated: Bool) {
        loadMoreItems()
    }
    //MARK: - Methods -
    init() {
        super.init(nibName: "SmilesExplorerPickTicketPopUp", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func styleFontAndTextColor() {
        self.headingLabel.fontTextStyle = .smilesHeadline3
        self.detailLabel.fontTextStyle = .smilesBody3
        //self.upgradeButton.fontTextStyle = .smilesBody4
    }
    private func setupUI() {
        
        setupCollectionView()
        self.upgradeButton.setTitle("Upgrade".localizedString, for: .normal)
        mainContainerView.clipsToBounds = true
        mainContainerView.layer.cornerRadius = 16
        mainContainerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        view.backgroundColor = .appRevampFilterTextColor.withAlphaComponent(0.6)
    }
    func bind(to viewModel: SmilesExplorerPickTicketViewModel) {
        input = PassthroughSubject<SmilesExplorerPickTicketViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                    
                case .getSmilesExplorerTickesDidSucceed(let response):
                    var response = response
                    SmilesLoader.dismiss(from: self?.view ?? UIView())
                    guard response.offers?.count ?? 0 > 0 else {
                        self?.hasMoreData = false
                        return
                    }
                    response.offers?.append(contentsOf: self?.response?.offers ?? [])
                    self?.response = response
                    self?.headingLabel.text = response.listTitle
                    self?.detailLabel.text = response.listSubtitle
                    self?.hasMoreData = self?.response?.offersCount ?? 0 > self?.response?.offers?.count ?? 0
                    self?.isLoading = false
                    self?.currentPage += 1
                    self?.ticketsCollectionView.reloadData()
                case .getSmilesExplorerTickesDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    func bindMemberShip(to viewModel: SmilesExplorerMembershipSelectionViewModel) {
        inputMemberShip = PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never>()
        let output = viewModelMenberShip.transform(input: inputMemberShip.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSubscriptionInfoDidSucceed(response: let response):
                    self?.responseMemberShip = response
                    
                    
                case .fetchSubscriptionInfoDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    // MARK: - Pagination
    
    func loadMoreItems() {
        print("fetching \(currentPage)")
        isLoading = true
        input.send(.fetchSmilesExplorerTickets(page: currentPage))
    }
    private func setupCollectionView() {
        
        ticketsCollectionView.register(UINib(nibName: String(describing: SmilesExplorerHomeTicketsCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: SmilesExplorerHomeTicketsCollectionViewCell.self))
        ticketsCollectionView.dataSource = self
        ticketsCollectionView.delegate = self
}
    
    
    //MARK: - IBActions -
    @IBAction func upgradeButtonDidTab(_ sender: UIButton) {
        let objSmilesExplorerPaymentParams = SmilesExplorerPaymentParams(lifeStyleOffer: self.responseMemberShip?.lifestyleOffers?.first, isComingFromSpecialOffer: false, isComingFromTreasureChest: false)
        paymentDelegate?.proceedToPayment(params: objSmilesExplorerPaymentParams, navigationType: .payment)
        self.dismiss(animated: true)
    }
    @IBAction func crossButtonDidTab(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

 // MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE -
extension SmilesExplorerPickTicketPopUp: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.response?.offers?.count ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let currentCount = response?.offers?.count ?? 0
        if currentCount > 0 && indexPath.row == currentCount - 1 && !isLoading && hasMoreData {
            loadMoreItems()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let data = self.response?.offers?[safe: indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmilesExplorerHomeTicketsCollectionViewCell", for: indexPath) as? SmilesExplorerHomeTicketsCollectionViewCell else {return UICollectionViewCell()}
            cell.brandTitleLabel.text = data.offerTitle
            cell.typeLabel.text = AppCommonMethods.languageIsArabic() ?  data.offerTypeAr:data.offerType
            cell.brandLogoImageView.setImageWithUrlString(data.imageURL ?? "")
            let aed = "AED".localizedString
            cell.amountLabel.attributedText = "\(String(describing: data.originalDirhamValue ?? "")) \(aed)".strikoutString(strikeOutColor: .appGreyColor_128)
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if let data = collectionsData?[indexPath.row] {
//            callBack?(data)
//        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/4, height: 130)
    }

}

