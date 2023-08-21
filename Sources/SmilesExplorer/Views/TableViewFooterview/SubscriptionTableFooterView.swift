//
//  File.swift
//  
//
//  Created by Habib Rehman on 21/08/2023.
//

import Foundation
import UIKit
import SmilesFontsManager
import SmilesUtilities



class SubscriptionTableFooterView: UITableViewHeaderFooterView {
    
    let promoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "SubAddPromo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let promoCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Apply promo code"
        label.font = .montserratMediumFont(size: 12.0)
        label.textColor = .appRevampPurpleMainColor
        label.textAlignment = .left
        return label
    }()
    
    let applyPromoCodeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        
        contentView.addSubview(promoImageView)
        contentView.addSubview(promoCodeLabel)
        contentView.addSubview(applyPromoCodeButton)
        
        NSLayoutConstraint.activate([
            promoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            promoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            promoImageView.widthAnchor.constraint(equalToConstant: 10),
            promoImageView.heightAnchor.constraint(equalToConstant: 10),
            
            promoCodeLabel.leadingAnchor.constraint(equalTo: promoImageView.leadingAnchor, constant: 20),
            promoCodeLabel.centerYAnchor.constraint(equalTo: promoImageView.centerYAnchor),
            
            applyPromoCodeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            applyPromoCodeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            applyPromoCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            applyPromoCodeButton.bottomAnchor.constraint(equalTo: promoCodeLabel.topAnchor)
        ])
    }
}

