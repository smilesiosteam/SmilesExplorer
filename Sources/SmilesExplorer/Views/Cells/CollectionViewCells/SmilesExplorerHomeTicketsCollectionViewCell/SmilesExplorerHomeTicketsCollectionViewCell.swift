//
//  SmilesExplorerHomeTicketsCollectionViewCell.swift
//  
//
//  Created by Ghullam  Abbas on 18/08/2023.
//

import UIKit
import SmilesUtilities

class SmilesExplorerHomeTicketsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var brandLogoImageView: UIImageView!
    @IBOutlet weak var brandTitleLabel: UILocalizableLabel!
    @IBOutlet weak var typeLabel: UILocalizableLabel!
    @IBOutlet weak var amountLabel: UILocalizableLabel!
    //MARK: - Variables
    
    //MARK: - CellView LifeCycel
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    //MARK: - Helper Function
    private func setupUI() {
        self.imageContainerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 36.0)
        imageContainerView.layer.borderWidth = 1.0
        imageContainerView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        brandLogoImageView.layer.cornerRadius = 36.0
        self.brandTitleLabel.fontTextStyle = .smilesTitle2
        self.typeLabel.fontTextStyle = .smilesBody4
        self.amountLabel.fontTextStyle = .smilesLabel1
        self.brandTitleLabel.textColor = .appRevampLocationTextColor
        self.typeLabel.textColor = .appRevampSubtitleColor
        self.amountLabel.textColor = .appRevampSubtitleColor
        self.amountLabel.attributedText = "".strikoutString(strikeOutColor: .appGreyColor_128)
    }
    
    func configure(offer: ExplorerOffer) {
        print(offer)
        
        let attributeString = NSMutableAttributedString(string: "\(offer.dirhamValue ?? "") \("AED".localizedString)")
        attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
        amountLabel.attributedText = attributeString
        self.brandTitleLabel.localizedString = offer.offerTitle ?? ""
        self.typeLabel.localizedString = offer.offerType ?? ""
        brandLogoImageView.setImageWithUrlString(offer.partnerImage.asStringOrEmpty(),defaultImage: "", backgroundColor: .white) { image in
            if let image = image {
                self.brandLogoImageView.image = image
            }
        }
        
        amountLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        brandTitleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        typeLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        
    }
    
}
