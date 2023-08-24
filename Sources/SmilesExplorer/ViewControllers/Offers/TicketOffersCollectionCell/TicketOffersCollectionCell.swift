//
//  ItemCategoriesCollectionViewCell.swift
//  House
//
//  Created by Muhammad Shayan Zahid on 28/11/2022.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import LottieAnimationManager
import SmilesUtilities
import SmilesOffers

class TicketOffersCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILocalizableLabel!
    @IBOutlet weak var mainView: UIView!

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var freeLbl: UILabel!
    
    @IBOutlet weak var originalPriceLbl: UILabel!
    
    @IBOutlet weak var radioBtnImageView: UIImageView!
    
    @IBOutlet var pointsIcon: UIImageView!
    @IBOutlet var offerPointsLabel: UILabel!
    @IBOutlet var offerPriceLabel: UILabel!
    @IBOutlet var offerOrSeparatorLabel: UILabel!
    @IBOutlet var lottieAnimationView: UIView!
    @IBOutlet var smileyPointsView: UIView!
    
    @IBOutlet weak var freeView: UIView!
    var offer:OfferDO!{
        didSet{
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    func setupUI() {
        mainView.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.831372549, blue: 0.8509803922, alpha: 1)
        mainView.layer.cornerRadius = 16
        mainView.layer.borderWidth = 1
        
        imageView.layer.borderColor = #colorLiteral(red: 0.8235294118, green: 0.831372549, blue: 0.8509803922, alpha: 1)
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        
        freeLbl.text = "Free".localizedString
        imageView.contentMode = .scaleAspectFill
        
        descLbl.textColor = #colorLiteral(red: 0.4745098039, green: 0.4901960784, blue: 0.5529411765, alpha: 1)
        freeLbl.textColor = UIColor(white: 0, alpha: 0.6)
        originalPriceLbl.textColor = UIColor(white: 0, alpha: 0.6)
    }
    
    private func configure(){
        imageView.setImageWithUrlString(offer.imageURL ?? "")
        titleLbl.text = offer.offerTitle
        descLbl.text = offer.offerDescription
        if let points = offer.pointsValue, points != "0", let price = offer.dirhamValue, price != "0" {
            setPointsIcon(with: offer.smileyPointsUrl.asStringOrEmpty())
            freeView.isHidden = true
            smileyPointsView.isHidden = false
            
            offerPointsLabel.text = "\(points) \("PTS".localizedString)"
            offerPriceLabel.text = "\(price) \("AED".localizedString)"
            offerOrSeparatorLabel.text = "or".localizedString
            offerOrSeparatorLabel.isHidden = false
            offerPriceLabel.isHidden = false

        } else {
            freeView.isHidden = false
            smileyPointsView.isHidden = true
            let attributeString = NSMutableAttributedString(string: "\(offer.originalDirhamValue ?? "") \("AED".localizedString)")
            attributeString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributeString.length))
            originalPriceLbl.attributedText = attributeString
        }
        self.contentView.sizeToFit()
    }
    func setPointsIcon(with iconURL: String?) {
        if let iconJsonAnimationUrl = iconURL, !iconJsonAnimationUrl.isEmpty {
            lottieAnimationView.isHidden = false
            pointsIcon.isHidden = true
            lottieAnimationView.subviews.forEach({ $0.removeFromSuperview() })
            LottieAnimationManager.showAnimationFromUrl(FromUrl: iconJsonAnimationUrl, animationBackgroundView: self.lottieAnimationView, removeFromSuper: false, loopMode: .playOnce, shouldAnimate: false) { _ in }
            
        } else {
            pointsIcon.isHidden = false
            lottieAnimationView.isHidden = true
        }
    }
}
