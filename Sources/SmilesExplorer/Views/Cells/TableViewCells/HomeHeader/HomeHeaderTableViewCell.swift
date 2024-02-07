//
//  HomeHeaderTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 05/02/2024.
//

import UIKit
import SmilesUtilities

class HomeHeaderTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - PROPERTIES -
    
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupData(header: HomeHeaderResponse) {
        headerTitle.text = header.headerTitle
        headerImageView.setImageWithUrlString(header.headerImage ?? "")
    }
    
    func setBackGroundColor(color: UIColor) {
        bgView.backgroundColor = color
    }
    
}
