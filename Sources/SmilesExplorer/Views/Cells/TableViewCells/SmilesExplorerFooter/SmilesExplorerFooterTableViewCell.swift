//
//  SmilesExplorerFooterTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 17/08/2023.
//

import UIKit
import SmilesUtilities

class SmilesExplorerFooterTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var subscriptionImageView: UIImageView!
    
    
    // MARK: - PROPERTIES -
    var getMembership: (() -> Void)?
    
    // MARK: - ACTIONS -
    @IBAction func getMembershipPressed(_ sender: Any) {
        getMembership?()
    }
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupValues(url: String) {
        subscriptionImageView.setImageWithUrlString(url)
    }
    
}
