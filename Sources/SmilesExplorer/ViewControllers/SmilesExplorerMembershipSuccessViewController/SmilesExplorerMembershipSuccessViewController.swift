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
    
    private var model: SmilesExplorerSubscriptionInfoResponse?
    private let sourceScreen: SourceScreen
    lazy  var backButton: UIButton = UIButton(type: .custom)
    
    // MARK: - ViewController Lifecycle -
   
    public override func viewDidLoad() {
        super.viewDidLoad()
            styleFontAndTextColor()
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Methods -
    init(model: SmilesExplorerSubscriptionInfoResponse?,sourceScreen: SourceScreen) {
        
        self.model = model
        self.sourceScreen = sourceScreen
        super.init(nibName: "SmilesExplorerMembershipSuccessViewController", bundle: .module)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUpNavigationBar(self.sourceScreen == .freePassSuccess ? true: false)
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
        
        locationNavBarTitle.text = self.model?.themeResources?.explorerSubscriptionTitle ?? "Success"
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
        self.setupUI()
    }
    
    private func setupUI() {
       
        setButtonsAndDateORLinkUI()
        
        congratulationLabel.fontTextStyle = .smilesHeadline3
        detailLabel.fontTextStyle = .smilesBody3
        dateORLinkButton.fontTextStyle = .smilesTitle1
        continueButton.fontTextStyle = .smilesTitle1
        exploreButton.fontTextStyle = .smilesTitle1
        continueButton.setTitle( "ContinueTitle".localizedString.capitalized, for: .normal)
        congratulationLabel.text = self.model?.themeResources?.explorerPurchaseSuccessTitle
        if let urlStr = self.model?.themeResources?.explorerPurchaseSuccessImage, !urlStr.isEmpty {
            imgView.isHidden = false
            if urlStr.hasSuffix(".json") {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: urlStr, animationBackgroundView: self.imgView, removeFromSuper: false, loopMode: .loop, shouldAnimate: true) { _ in }
            }else{
                self.imgView.setImageWithUrlString(urlStr)
            }
        } else {
            imgView.isHidden = true
        }
        
        detailLabel.text =  (self.model?.themeResources?.passPurchaseSuccessMsg ?? "") +  (self.model?.themeResources?.explorerSubscriptionSubTitle ?? "")
        
        
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
                    string: "View free pass",
                    attributes: underLineAttributes
                 )
            self.dateORLinkButton.setAttributedTitle(attributeString, for: .normal)
            
            self.dateORLinkButton.isUserInteractionEnabled = true
            self.linkArrowImageView.isHidden = false
        case.success:
            self.backButton.isHidden = true
            self.exploreButton.isHidden = true
            self.continueButton.isHidden = false
            if let expiryDateString =  self.model?.lifestyleOffers?.first?.expiryDate {
                let outputDateString = expiryDateString.convertDate(from: "dd-MM-yyyy", to: "dd MMM YYYY")
                dateORLinkButton.setTitle(outputDateString, for: .normal)
            }
            
        }
        self.exploreButton.titleLabel?.textColor = .appRevampFilterCountBGColor

    }
    
    // MARK: - IBActions -
    @IBAction func continueButtonDidTab(_ sender: UIButton) {
        
    }
    @IBAction func exploreButtonDidTab(_ sender: UIButton) {
        
    }
    @objc func onClickBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
