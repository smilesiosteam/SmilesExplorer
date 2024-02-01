//
//  SmilesExplorerMembershipCardsTableViewCell.swift
//  
//
//  Created by Habib Rehman on 17/08/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

class SmilesExplorerMembershipCardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var platinumExplorerLabel: UILocalizableLabel!
    @IBOutlet weak var choiceTicketLabel: UILocalizableLabel!
    @IBOutlet weak var exclusiveOfferLabel: UILocalizableLabel!
    @IBOutlet weak var buy1Get1Label: UILocalizableLabel!
    @IBOutlet weak var priceLabel: UILocalizableLabel!
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!
    
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var cardView: UIView!
    
    
//    typealias FavHandler = (Bool) -> Void
//    var favHandler: FavHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellUI()
    }
    
    
    private func setupCellUI(){
        self.cardView.layer.cornerRadius = 12.0
        self.cardView.layer.borderColor = UIColor.lightGray.cgColor
        self.cardView.layer.borderWidth = 1
        
        //TypoGraphy Setup
        self.platinumExplorerLabel.fontTextStyle = .smilesHeadline3
        self.choiceTicketLabel.fontTextStyle = .smilesTitle3
        self.exclusiveOfferLabel.fontTextStyle = .smilesTitle3
        self.buy1Get1Label.fontTextStyle = .smilesTitle3
        self.priceLabel.fontTextStyle = .smilesHeadline4
        
        //TypoGraphy Color
        self.platinumExplorerLabel.textColor = UIColor(hexString: "#e6000000")
        self.choiceTicketLabel.textColor = UIColor(hexString: "#383838")
        self.exclusiveOfferLabel.textColor = UIColor(hexString: "#383838")
        self.buy1Get1Label.textColor = UIColor(hexString: "#383838")
        self.priceLabel.textColor = UIColor(hexString: "#e6000000")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.toggleButton.isSelected = selected ? true:false
    }
    
    func configureCell(with data: BOGODetailsResponseLifestyleOffer) {
        platinumExplorerLabel.text = data.offerTitle ?? ""
        let labels = [choiceTicketLabel, exclusiveOfferLabel, buy1Get1Label]
        let texts = data.whatYouGetTextList ?? []

        for (index, label) in labels.enumerated() {
            if index < texts.count {
                label?.text = texts[index]
            } else {
                label?.isHidden = true
            }
        }

        let pricePkg: String? = Int(exactly: data.price ?? 0.0).map { String($0) }

        
        priceLabel.text = "\(pricePkg ?? "") \("AED".localizedString)"
        cellImageView.setImageWithUrlString(data.subscribeImage ?? "")
        cellImageView.backgroundColor = .clear
        platinumExplorerLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        choiceTicketLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        exclusiveOfferLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        buy1Get1Label.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        priceLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        
        
    }
    
    
    
}
