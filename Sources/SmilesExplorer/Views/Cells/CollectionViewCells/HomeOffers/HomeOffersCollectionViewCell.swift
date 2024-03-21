//
//  HomeOffersCollectionViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 06/02/2024.
//

import UIKit
import SmilesOffers

class HomeOffersCollectionViewCell: UICollectionViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var partnerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var contentBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var contentBottomSpaceEqual: NSLayoutConstraint!
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        
        offerImageView.layer.cornerRadius = 12
        partnerImageView.layer.cornerRadius = partnerImageView.frame.height / 2
        partnerImageView.clipsToBounds = true
        partnerImageView.layer.borderWidth = 1
        partnerImageView.layer.borderColor = UIColor.white.cgColor
        
    }
    
    func setupData(offer: OfferDO, isForTickets: Bool = true) {
        
        titleLabel.text = offer.offerTitle
        titleLabel.numberOfLines = isForTickets ? 2 : 3
        priceStackView.isHidden = !isForTickets
        offerImageView.setImageWithUrlString(offer.imageURL ?? "")
        partnerImageView.setImageWithUrlString(offer.partnerImage ?? "")
        contentBottomSpace.priority = .defaultLow
        contentBottomSpaceEqual.priority = isForTickets ? .defaultHigh : .defaultLow
        if isForTickets {
            let dirhamValue = offer.originalDirhamValue ?? "0.00"
            let attributeString = NSMutableAttributedString(string: "\("AED".localizedString) \(dirhamValue)")
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            amountLabel.attributedText = attributeString
            if let price = offer.dirhamValue, price != "0" && price != "0.00" {
                self.typeLabel.text = "AED".localizedString + (offer.dirhamValue ?? "")
            } else {
                self.typeLabel.text = "Free".localizedString.capitalizingFirstLetter()
            }
        }
        
    }

}
