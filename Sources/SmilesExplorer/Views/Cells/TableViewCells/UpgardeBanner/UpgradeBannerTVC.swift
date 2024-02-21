//
//  UpgardeBannerTVC.swift
//
//
//  Created by Habib Rehman on 06/09/2023.
//

import UIKit
import SmilesUtilities
import SmilesSharedServices


class UpgradeBannerTVC: UITableViewCell {
    
    @IBOutlet weak var imgBanner: UIImageView!
    
    var onClickUpgrade: (() -> ())?
    
    var sectionData:SectionDetailDO?{
        didSet{
            guard let sec = sectionData else {return}
            self.configureBanner(objSection: sec)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgBanner.backgroundColor = .appRevampPurpleMainColor
        self.imgBanner.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configureBanner(objSection:SectionDetailDO){
        self.imgBanner.sd_setImage(with: URL(string: objSection.backgroundImage.asStringOrEmpty())) { image, _, _, _ in
            self.imgBanner.image = image
        }
    }
    
}
