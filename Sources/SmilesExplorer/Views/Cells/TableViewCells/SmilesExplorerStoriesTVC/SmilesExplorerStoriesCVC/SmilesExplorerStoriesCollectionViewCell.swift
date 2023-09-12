//
//  StoriesCollectionViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/26/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesStoriesManager
import SmilesUtilities
import Foundation


public class SmilesExplorerStoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var imgOverlay: StoriesSZGradientView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        title.font = .circularXXTTMediumFont(size: 14)
        title.textColor = .appRevampLocationTextColor
        
        descriptionLabel.font = .circularXXTTBookFont(size: 12)
        descriptionLabel.textColor = .appRevampSubtitleColor
                imgOverlay.showGradientColor(with: [UIColor.black.withAlphaComponent(0.3).cgColor,
                                                    UIColor.black.withAlphaComponent(0).cgColor], for: "bottom")
                imgOverlay.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: 8.0)
        imgOverlay.locations = [0.25, 0.54, 0.83]
        imgOverlay.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.black.withAlphaComponent(0.85).cgColor
        ]
        imgOverlay.direction = 2
        imgOverlay.layer.cornerRadius = 8
        imgOverlay.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        icon.addBorder(withBorderWidth: 1, borderColor: .white)
        
        image.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 8.0)
        icon.addMaskedCorner(withMaskedCorner: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: icon.frame.height / 2)
    }
    
     func configure(storyOffer: ExplorerOffer) {
         image.setImageWithUrlString(storyOffer.imageURL.asStringOrEmpty()) { image in
            if let image = image {
                self.image.image = image
            }
        }
        
        icon.setImageWithUrlString(storyOffer.partnerImage.asStringOrEmpty()) { image in
            if let image = image {
                self.icon.image = image
            }
        }
        
        title.text = storyOffer.offerTitle
        descriptionLabel.text = storyOffer.offerDescription
    }
}
