//
//  OfferDetailPopupHeaderTVC.swift
//  
//
//  Created by Habib Rehman on 27/02/2024.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities
import SmilesOffers

class OfferDetailPopupHeaderTVC: UITableViewCell {

    @IBOutlet weak var imgOffer: UIImageView!
    @IBOutlet weak var lblOfferTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        self.imgOffer.layer.cornerRadius = 16.0
        self.imgOffer.contentMode = .scaleAspectFill
        self.lblOfferTitle.fontTextStyle = .smilesHeadline2
        self.lblOfferTitle.textColor = .black
        self.lblOfferTitle.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
    }
    
    func setupData(offer: OfferDetailsResponse){
        self.lblOfferTitle.text = offer.offerTitle
        self.imgOffer.setImageWithUrlString(offer.offerImageUrl ?? "")
    }

    
    
}
