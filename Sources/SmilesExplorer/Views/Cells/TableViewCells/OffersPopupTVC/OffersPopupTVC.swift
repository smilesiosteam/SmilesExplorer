//
//  OffersPopupTVC.swift
//
//
//  Created by Habib Rehman on 15/02/2024.
//

import UIKit

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
        
    }
    
    func showHide(isDummy: Bool) {
        if isDummy {
            self.contentView.enableSkeleton()
            self.contentView.showAnimatedGradientSkeleton()
        } else {
            self.contentView.hideSkeleton()
        }
    }
    
    // MARK: - Configuration
    func configure(title: String) {
        titleLabel.text = title
    }
}
