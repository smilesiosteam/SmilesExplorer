//
//  SmilesExplorerHomeTicketsCollectionViewCell.swift
//  
//
//  Created by Ghullam  Abbas on 18/08/2023.
//

import UIKit

class SmilesExplorerHomeTicketsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var brandLogoImageView: UIImageView!
    @IBOutlet weak var brandTitleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    //MARK: - Variables
    
    //MARK: - CellView LifeCycel
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    
    //MARK: - Helper Function
    private func setupUI() {
        self.imageContainerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 12.0)
        self.brandTitleLabel.fontTextStyle = .smilesTitle2
        self.typeLabel.fontTextStyle = .smilesLabel2
        self.amountLabel.fontTextStyle = .smilesLabel1
        self.brandTitleLabel.textColor = .appRevampLocationTextColor
        self.typeLabel.textColor = .appRevampSubtitleColor
        self.amountLabel.textColor = .appRevampSubtitleColor
        self.amountLabel.attributedText = "".strikoutString(strikeOutColor: .appGreyColor_128)
    }
    
    func configure(offer: ExplorerOffer) {
        print(offer)
        self.amountLabel.text = offer.pointsValue
        self.brandTitleLabel.text = offer.offerTitle
        self.typeLabel.text = offer.offerType
        brandLogoImageView.setImageWithUrlString(offer.imageURL.asStringOrEmpty(), backgroundColor: .white) { image in
            if let image = image {
                self.brandLogoImageView.image = image
            }
        }
        
    }
    
}
