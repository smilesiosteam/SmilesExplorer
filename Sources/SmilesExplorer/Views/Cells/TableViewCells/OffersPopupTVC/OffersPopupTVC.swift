//
//  OffersPopupTVC.swift
//
//
//  Created by Habib Rehman on 15/02/2024.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

class OffersPopupTVC: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView! = {
        let iconImageView = UIImageView()
            iconImageView.image = UIImage(named: "checkGreen1")?.withRenderingMode(.alwaysTemplate)
            return iconImageView
    }()
    
    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func setupUI(){
        self.titleLabel.fontTextStyle = .smilesBody2
        self.titleLabel.textColor = UIColor(white: 0.0, alpha: 0.8)
        self.titleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
    }
    // MARK: - Configuration
    func configure(title: String) {
        titleLabel.text = title
    }
}
