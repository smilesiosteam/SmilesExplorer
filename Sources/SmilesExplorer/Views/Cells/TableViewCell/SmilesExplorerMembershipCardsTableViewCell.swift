//
//  SmilesExplorerMembershipCardsTableViewCell.swift
//  
//
//  Created by Habib Rehman on 17/08/2023.
//

import UIKit
import SmilesFontsManager
import SmilesUtilities

class SmilesExplorerMembershipCardsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var platinumExplorerLabel: UILabel!
    @IBOutlet weak var choiceTicketLabel: UILabel!
    @IBOutlet weak var exclusiveOfferLabel: UILabel!
    @IBOutlet weak var buy1Get1Label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Example method to configure cell content
    func configureCell(with data: BOGODetailsResponseLifestyleOffer) {
        platinumExplorerLabel.text = data.whatYouGetText
        choiceTicketLabel.text = data.whatYouGetText
        exclusiveOfferLabel.text = data.whatYouGetText
        buy1Get1Label.text = data.whatYouGetText
        priceLabel.text = data.whatYouGetText
        
        
    }
    
    
}
