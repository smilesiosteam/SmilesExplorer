//
//  SmilesExplorerFilterSelectionTVC.swift
//
//
//  Created by Habib Rehman on 14/09/2023.
//

import UIKit

class SmilesExplorerFilterSelectionTVC: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .montserratMediumFont(size: 15.0)
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
