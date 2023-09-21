//
//  SmilesExplorerDealsAndOffersCollectionViewCell.swift
//  
//
//  Created by Ghullam  Abbas on 18/08/2023.
//

import UIKit

class SmilesExplorerDealsAndOffersCollectionViewCell: UICollectionViewCell {
    //MARK: - IBOutlets -
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var brandLogoImageView: UIImageView!
    @IBOutlet weak var brandTitleLabel: UILabel!
    
    //MARK: - Variables
    //MARK: - CellView LifeCycel
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        // Initialization code
    }
    //MARK: - Helper Function
    private func setupUI() {
        self.imageContainerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: self.imageContainerView.frame.height/2)
        imageContainerView.layer.borderWidth = 1.0
        imageContainerView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        brandLogoImageView.layer.cornerRadius =  self.brandLogoImageView.frame.height/2
        self.brandTitleLabel.fontTextStyle = .smilesTitle2
        self.brandTitleLabel.textColor = .appRevampLocationTextColor
        
    }
    
    func configure(offer: ExplorerOffer) {
        print(offer)
        self.brandTitleLabel.text = offer.offerTitle
        brandLogoImageView.setImageWithUrlString(offer.partnerImage.asStringOrEmpty(), backgroundColor: .white) { image in
            if let image = image {
                self.brandLogoImageView.image = image
            }
        }
        
    }
}
