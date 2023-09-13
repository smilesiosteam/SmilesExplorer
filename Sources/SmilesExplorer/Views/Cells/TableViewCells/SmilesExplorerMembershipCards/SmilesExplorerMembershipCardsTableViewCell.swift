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
    var callBack: (() -> Void)?
    
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
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.toggleButton.isSelected = selected ? true:false
    }
    
    @IBAction func selectinoButtonPressed(_ sender: Any) {
        callBack?()
    }
    
    func configureCell(with data: BOGODetailsResponseLifestyleOffer) {
        platinumExplorerLabel.localizedString = data.whatYouGetTitle ?? ""
        choiceTicketLabel.localizedString = data.whatYouGetTextList?.first ?? ""
        exclusiveOfferLabel.localizedString = data.whatYouGetTextList?[1] ?? ""
        buy1Get1Label.localizedString = data.whatYouGetTextList?[safe:2] ?? ""
        priceLabel.localizedString = data.monthlyPrice ?? ""
        cellImageView.setImageWithUrlString(data.subscribeImage ?? "")
        
        platinumExplorerLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        choiceTicketLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        exclusiveOfferLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        buy1Get1Label.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        priceLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        
        
    }
    
    
    
}
