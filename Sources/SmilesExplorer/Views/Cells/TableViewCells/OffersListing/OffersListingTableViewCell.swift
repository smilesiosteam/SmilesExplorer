//
//  OffersListingTableViewCell.swift
//
//
//  Created by Abdul Rehman Amjad on 08/02/2024.
//

import UIKit
import SmilesOffers

class OffersListingTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    //MARK: - Setup UI
    private func setupViews() {
        
        offerImageView.layer.cornerRadius = 12
        partnerImageView.layer.cornerRadius = partnerImageView.frame.height / 2
        partnerImageView.clipsToBounds = true
        partnerImageView.layer.borderWidth = 1
        partnerImageView.layer.borderColor = UIColor.white.cgColor
        
    }
    
    //MARK: - Data Configuration
    func setupData(offer: OfferDO) {
        
        self.titleLabel.text = offer.offerTitle
        self.subTitleLabel.text = offer.offerDescription
        self.offerImageView.setImageWithUrlString(offer.imageURL ?? "")
        self.partnerImageView.setImageWithUrlString(offer.partnerImage ?? "")
        
        if let price = offer.dirhamValue, (price != "0" && price != "0.00") {
            typeLabel.isHidden = true
            priceLabel.text = ("AED".localizedString) + " " + price
        } else {
            typeLabel.text = "Free".localizedString.capitalizingFirstLetter()
            typeLabel.isHidden = false
            let attributeString = NSMutableAttributedString(string: "\("AED".localizedString) 0.00")
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            priceLabel.attributedText = attributeString
        }
        
    }
    
}
