//
//  SmilesExplorerMembershipSuccessViewController.swift
//  
//
//  Created by Ghullam  Abbas on 15/08/2023.
//

import UIKit
import SmilesUtilities
import Combine
import LottieAnimationManager
import SmilesLanguageManager
import SmilesFontsManager
import SmilesLoader

public enum SourceScreen {
    case success
    case freePassSuccess
}

public class SmilesExplorerMembershipSuccessViewController: UIViewController {
    
    // MARK: - IBOutlets -
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var linkArrowImageView: UIImageView!
    @IBOutlet weak var congratulationLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateORLinkButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var exploreButton: UIButton!
    
    // MARK: - Properties -
    var transactionId: String?
    private var onContinue:((String?) -> Void)?
   // private var model: SmilesExplorerSubscriptionInfoResponse?
    
    lazy  var backButton: UIButton = UIButton(type: .custom)
    var membershipPicked:((BOGODetailsResponseLifestyleOffer)->Void)? = nil
    
    private let sourceScreen: SourceScreen
    private var response: SmilesExplorerSubscriptionInfoResponse?
    private var input: PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    private lazy var viewModel: SmilesExplorerMembershipSelectionViewModel = {
        return SmilesExplorerMembershipSelectionViewModel()
    }()
    
    // MARK: - ViewController Lifecycle -
   
    public override func viewDidLoad() {
        super.viewDidLoad()
            styleFontAndTextColor()
        bind(to: viewModel)
        input.send(.getSubscriptionInfo)
        // Do any additional setup after loading the view.
    }
    // MARK: - Methods -
    init(_ sourceScreen: SourceScreen,transactionId: String?,onContinue: ((String?) -> Void)?) {
        self.transactionId = transactionId
        self.onContinue = onContinue
        self.sourceScreen = sourceScreen
        super.init(nibName: "SmilesExplorerMembershipSuccessViewController", bundle: .module)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func bind(to viewModel: SmilesExplorerMembershipSelectionViewModel) {
        input = PassthroughSubject<SmilesExplorerMembershipSelectionViewModel.Input, Never>()
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output
            .sink { [weak self] event in
                switch event {
                case .fetchSubscriptionInfoDidSucceed(response: let response):
                    self?.response = response
                    self?.setupUI()
                    
                case .fetchSubscriptionInfoDidFail(error: let error):
                    debugPrint(error.localizedDescription)
                }
            }.store(in: &cancellables)
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    private func setUpNavigationBar(_ showBackButton: Bool = false) {
       
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        let locationNavBarTitle = UILabel()
        
        locationNavBarTitle.text = self.response?.themeResources?.explorerSubscriptionTitle ?? "Success"
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        locationNavBarTitle.textColor = .appRevampPurpleMainColor
        

        self.navigationItem.titleView = locationNavBarTitle
        /// Back Button Show
        
            self.backButton = UIButton(type: .custom)
            // btnBack.backgroundColor = UIColor(red: 226.0 / 255.0, green: 226.0 / 255.0, blue: 226.0 / 255.0, alpha: 1.0)
            self.backButton.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "purple_back_arrow_ar" : "purple_back_arrow", in: .module, compatibleWith: nil), for: .normal)
            self.backButton.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
            self.backButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            self.backButton.layer.cornerRadius = self.backButton.frame.height / 2
            self.backButton.clipsToBounds = true
            
            let barButton = UIBarButtonItem(customView: self.backButton)
            self.navigationItem.leftBarButtonItem = barButton
        if (!showBackButton) {
            self.backButton.isHidden = true
        }
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        
    }
    private func styleFontAndTextColor() {
       
        self.congratulationLabel.fontTextStyle = .smilesHeadline3
        self.detailLabel.fontTextStyle = .smilesBody3
        self.dateORLinkButton.fontTextStyle = .smilesBody4
        self.continueButton.fontTextStyle = .smilesHeadline4
        self.exploreButton.fontTextStyle = .smilesHeadline4
        self.detailLabel.textColor = .appDarkGrayColor
        self.congratulationLabel.textColor = .appDarkGrayColor
        self.dateORLinkButton.titleLabel?.textColor = .appRevampSubtitleColor
        
    }
    
    private func setupUI() {
        self.setUpNavigationBar(self.sourceScreen == .freePassSuccess ? true: false)
        setButtonsAndDateORLinkUI()
        
        continueButton.setTitle( "ContinueTitle".localizedString.capitalized, for: .normal)
        self.exploreButton.setTitle("Go to explorer", for: .normal)
        congratulationLabel.text = self.response?.themeResources?.explorerPurchaseSuccessTitle
        if let urlStr = self.response?.themeResources?.explorerPurchaseSuccessImage, !urlStr.isEmpty {
            imgView.isHidden = false
            if urlStr.hasSuffix(".json") {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: urlStr, animationBackgroundView: self.imgView, removeFromSuper: false, loopMode: .loop, shouldAnimate: true) { _ in }
            }else{
                self.imgView.setImageWithUrlString(urlStr)
            }
        } else {
            imgView.isHidden = true
        }
        
        detailLabel.text =  (self.response?.themeResources?.passPurchaseSuccessMsg ?? "") + " " + (self.response?.themeResources?.explorerSubscriptionSubTitle ?? "")
        
        
    }
    func setButtonsAndDateORLinkUI() {
        
        switch self.sourceScreen {
        case.freePassSuccess:
            self.backButton.isHidden = false
            self.exploreButton.isHidden = false
            self.continueButton.isHidden = true
            let underLineAttributes: [NSAttributedString.Key: Any] = [
                .font: SmilesFonts.lato.getFont(style: .medium, size: 16) ,
                  .foregroundColor: UIColor.appRevampFilterCountBGColor,
                  .underlineStyle: NSUnderlineStyle.single.rawValue
              ] //
            let attributeString = NSMutableAttributedString(
                string: "View free pass".localizedString,
                    attributes: underLineAttributes
                 )
            self.dateORLinkButton.setAttributedTitle(attributeString, for: .normal)
            
            self.dateORLinkButton.isUserInteractionEnabled = true
            self.linkArrowImageView.isHidden = false
        case.success:
            self.backButton.isHidden = true
            self.exploreButton.isHidden = true
            self.continueButton.isHidden = false
            if let expiryDateString =  self.response?.lifestyleOffers?.first?.expiryDate {
                let outputDateString = expiryDateString.convertDate(from: "dd-MM-yyyy HH:mm:ss", to: "dd MMM, YYYY")
                let finalDateString = "*" + "Valid til".localizedString + " " + outputDateString
                dateORLinkButton.setTitle(finalDateString, for: .normal)
            }
            
        }
        self.exploreButton.titleLabel?.textColor = .appRevampFilterCountBGColor

    }
    
    // MARK: - IBActions -
    @IBAction func viewFreePassDidTab(_ sender: UIButton) {
        if let id = self.transactionId {
            self.onContinue?(id)
        }
    }
    @IBAction func continueButtonDidTab(_ sender: UIButton) {
        self.onContinue?(nil)
    }
    @IBAction func exploreButtonDidTab(_ sender: UIButton) {
        if let navController = self.navigationController {
            SmilesExplorerRouter.shared.popToSmilesExplorerHomeViewController(navVC: navController)
        }
    }
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
