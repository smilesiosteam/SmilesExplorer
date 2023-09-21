//
//  SmilesExplorerFooterTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 17/08/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices

class SmilesExplorerFooterTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var subscriptionImageView: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var footerBgView: UIView!
    @IBOutlet weak var explorerMembershipLabel: UILocalizableLabel!
    @IBOutlet weak var priceLabel: UILocalizableLabel!
    @IBOutlet weak var validityLabel: UILocalizableLabel!
    @IBOutlet weak var benefitsLable: UILocalizableLabel!
    
    @IBOutlet weak var fromLabel: UILocalizableLabel!
    // MARK: - PROPERTIES -
    var getMembership: (() -> Void)?
    
    // MARK: - ACTIONS -
    @IBAction func getMembershipPressed(_ sender: Any) {
        getMembership?()
    }
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        subscriptionImageView.contentMode = .scaleAspectFit
        topView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        // Initialization code
    }
    
    func setupValues(url: String) {
        subscriptionImageView.setImageWithUrlString(url)
    }
    
    // MARK: - CONFIGURATION METHODS -
    var footerconfiguration: SectionDetailDO? {
        didSet {
            guard let footerConfig = footerconfiguration else { return }
            self.setupFooterUI(model: footerConfig)
        }
    }

    private func setupFooterUI(model: SectionDetailDO) {
       
        self.explorerMembershipLabel.localizedString = model.title?.components(separatedBy: "\n").first ?? ""
        self.fromLabel.localizedString = (model.title?.components(separatedBy: "\n").last ?? "").components(separatedBy: " ").first ?? "from"
        self.priceLabel.localizedString = (model.title?.components(separatedBy: "\n").last ?? "").components(separatedBy: "from").last ?? ""
        self.validityLabel.localizedString = model.subTitle?.components(separatedBy: "\n").first ?? ""
        self.benefitsLable.localizedString = model.subTitle?.components(separatedBy: "\n\n")[1] ?? ""
//        self.footerBgView.backgroundColor = UIColor(hexString: model.backgroundColor ?? "")
        
        explorerMembershipLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        priceLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        validityLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        benefitsLable.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        fromLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
    }

    
}
