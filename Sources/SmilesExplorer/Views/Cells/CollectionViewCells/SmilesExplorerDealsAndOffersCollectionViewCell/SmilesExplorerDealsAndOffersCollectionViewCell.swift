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
        self.imageContainerView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner], cornerRadius: 12.0)
        self.brandTitleLabel.fontTextStyle = .smilesTitle2
       
        self.brandTitleLabel.textColor = .appRevampLocationTextColor
        
    }
}
