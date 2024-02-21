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
    
    var onClick = {}
    var onClickQR = {}
    
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
    
    lazy var scanGiftButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage.init(named: "iconOutlineQrCode", in: Bundle.module, compatibleWith: nil), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(QRCodeTapped), for: .touchUpInside)
        return button
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
    
    @objc func tapped(){
        onClick()
    }
    
    @objc func QRCodeTapped(){
        onClickQR()
    }
    
    private func commonInit() {
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        contentView.addSubview(promoImageView)
        contentView.addSubview(promoCodeLabel)
        contentView.addSubview(applyPromoCodeButton)
        contentView.addSubview(scanGiftButton)
        
        NSLayoutConstraint.activate([
            promoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            promoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            promoImageView.widthAnchor.constraint(equalToConstant: 10),
            promoImageView.heightAnchor.constraint(equalToConstant: 10),
            
            scanGiftButton.widthAnchor.constraint(equalToConstant: 32),
            scanGiftButton.heightAnchor.constraint(equalToConstant: 32),
            scanGiftButton.centerXAnchor.constraint(equalTo: promoCodeLabel.centerXAnchor),
            scanGiftButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            promoCodeLabel.leadingAnchor.constraint(equalTo: promoImageView.leadingAnchor, constant: 20),
            promoCodeLabel.centerYAnchor.constraint(equalTo: promoImageView.centerYAnchor),
            applyPromoCodeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            applyPromoCodeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            applyPromoCodeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            applyPromoCodeButton.bottomAnchor.constraint(equalTo: promoCodeLabel.topAnchor)
        ])
    }
}

