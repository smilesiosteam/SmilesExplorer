//
//  SmilesExplorerFooterTableViewCell.swift
//
//
//  Created by Abdul Rehman Amjad on 17/08/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices
import SmilesFontsManager

class SmilesExplorerFooterTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILocalizableLabel!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var mainView: UICustomView!
    
    // MARK: - PROPERTIES -
    private var gradientLayer: CAGradientLayer? = nil
    weak var delegate: ExplorerHomeFooterDelegate?
    
    // MARK: - ACTIONS -
    @IBAction func getMembershipPressed(_ sender: Any) {
        delegate?.getMembershipPressed()
    }
    
    @IBAction func faqPressed(_ sender: Any) {
        delegate?.faqsPressed()
    }
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    //MARK: - Setup UI
    private func setupViews() {
        
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedTitle = NSAttributedString(string: "Read FAQs".localizedString, attributes: attributes)
        faqButton.attributedText(attributedTitle, style: .smilesHeadline5, textColor: .white)
        subscriptionImageView.layer.cornerRadius = 16
        
    }
    
    func setupData(title: String?, footer: HomeFooter) {
        
        titleLabel.text = title
        subscriptionImageView.setImageWithUrlString(footer.explorerSubBannerBgImage ?? "")
        priceLabel.text = footer.explorerSubBannerPrice
        let lblDesc = footer.explorerSubBannerDescription?.replacingOccurrences(of: "{NEWLINE}", with: "\n")
        descriptionLabel.text = lblDesc
        setupGradient(colors: footer.explorerSubBannerBgColor ?? "#75428e|#424c99", direction: footer.explorerSubBannerColorDirection)
        
    }
    
    private func setupGradient(colors: String, direction: String?) {
        
        let backgroundGradientColors = colors.components(separatedBy: "|")
        let gradientColors = backgroundGradientColors.map({UIColor().colorWithHexString(hexString: $0).cgColor})
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = GradientUtility.shared.getGradientLayer(forView: mainView,
                                                                colors: gradientColors,
                                                                direction: direction ?? "left")
        mainView.layer.insertSublayer(gradientLayer!, at: 0)
        
    }
    
    
}
