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
    @IBOutlet weak var congratulationLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateORLinkButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    
    // MARK: - Properties -
    
    private var model: SmilesExplorerMembershipResponseModel?
    

    // MARK: - ViewController Lifecycle -
   
    public override func viewDidLoad() {
        super.viewDidLoad()
            styleFontAndTextColor()
        
        // Do any additional setup after loading the view.
    }
    // MARK: - Methods -
    init(model: SmilesExplorerMembershipResponseModel?,sourceScreen: SourceScreen = .freePassSuccess) {
        
        self.model = model
        super.init(nibName: "SmilesExplorerMembershipSuccessViewController", bundle: .module)
        switch sourceScreen {
        case.freePassSuccess:
            self.exploreButtonUI()
        case.success:
            break
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigationBar()
    }
    private func setUpNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .clear
        appearance.configureWithTransparentBackground()
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        let locationNavBarTitle = UILabel()
        locationNavBarTitle.text =  self.model?.themeResources.explorerSubscriptionTitle ?? ""
        locationNavBarTitle.textColor = .black
        locationNavBarTitle.fontTextStyle = .smilesHeadline4
        self.navigationItem.titleView = locationNavBarTitle
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    private func styleFontAndTextColor() {
       
        self.congratulationLabel.font = .circularXXTTBoldFont(size: 17)
        self.detailLabel.fontTextStyle = .smilesBody3
        self.dateORLinkButton.fontTextStyle = .smilesBody4
        self.actionButton.fontTextStyle = .smilesHeadline4
        self.detailLabel.textColor = .appDarkGrayColor
        self.congratulationLabel.textColor = .appDarkGrayColor
        self.dateORLinkButton.titleLabel?.textColor = .appRevampSubtitleColor
        
    }
    
    private func setupUI() {
        
        congratulationLabel.fontTextStyle = .smilesHeadline3
        detailLabel.fontTextStyle = .smilesBody3
        dateORLinkButton.fontTextStyle = .smilesTitle1
        actionButton.fontTextStyle = .smilesTitle1
        actionButton.setTitle( "ContinueTitle".localizedString.capitalized, for: .normal)
        congratulationLabel.text = self.model?.themeResources.explorerPurchaseSuccessTitle
        if let urlStr = self.model?.themeResources.explorerPurchaseSuccessImage, !urlStr.isEmpty {
            imgView.isHidden = false
            if urlStr.hasSuffix(".json") {
                LottieAnimationManager.showAnimationFromUrl(FromUrl: urlStr, animationBackgroundView: self.imgView, removeFromSuper: false, loopMode: .loop, shouldAnimate: true) { _ in }
            }else{
                self.imgView.setImageWithUrlString(urlStr)
            }
        } else {
            imgView.isHidden = true
        }
        
        detailLabel.text =  (self.model?.themeResources.passPurchaseSuccessMsg ?? "") +  (self.model?.themeResources.explorerSubscriptionSubTitle ?? "")
        if let expiryDateString =  self.model?.lifestyleOffers.first?.expiryDate {
            let outputDateString = expiryDateString.convertDate(from: "dd-MM-yyyy", to: "dd MMM YYYY")
            dateORLinkButton.setTitle(outputDateString, for: .normal)
        }
        
    }
    private func exploreButtonUI() {
        
        self.actionButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        self.actionButton.backgroundColor = .appDarkTextGreyColor
        self.actionButton.layer.borderColor = UIColor.appRevampPurpleMainColor.cgColor
        self.actionButton.layer.borderWidth = 1.5
        self.actionButton.setTitle("Go to explorer", for: .normal)
        self.actionButton.setImage(UIImage(named: "Arrows, Diagrams"), for: .normal)
    }
    // MARK: - IBActions -
    @IBAction func continueButtonDidTab(_ sender: UIButton) {
        
    }
}
