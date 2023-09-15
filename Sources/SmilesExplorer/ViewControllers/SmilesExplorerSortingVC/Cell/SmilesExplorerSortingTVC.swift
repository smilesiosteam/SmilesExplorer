//
//  SortingTableViewCell.swift
//  House
//
//  Created by Hannan on 27/09/2020.
//  Copyright © 2020 Ahmed samir ali. All rights reserved.
//

import Foundation
import SmilesUtilities
import SmilesOffers
import UIKit



class SmilesExplorerSortingTVC: UITableViewCell {
    
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .montserratMediumFont(size: 15.0)
        }
    }
    
    @IBOutlet var selectionImageView: UIImageView!
    @IBOutlet var bottomLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    

    
    
}
