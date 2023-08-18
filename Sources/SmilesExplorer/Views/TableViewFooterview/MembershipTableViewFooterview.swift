//
//  File.swift
//  
//
//  Created by Habib Rehman on 17/08/2023.
//

import Foundation
import SmilesUtilities
import SmilesLanguageManager
import UIKit

class MembershipTableViewFooterview: UIView {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var imgSubAddPromo: UIImageView!
    @IBOutlet weak var applyPromoCodeLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - METHODS -
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        Bundle.module.loadNibNamed("membershipTableviewFooterview", owner: self, options: nil)
//        addSubview(mainView)
//        mainView.frame = bounds
//        mainView.bindFrameToSuperviewBounds()
    }
    
//    func setupData(title: String?, subTitle: String?, color: UIColor?) {
//        titleLabel.localizedString = title ?? ""
//        subTitleLabel.localizedString = subTitle ?? ""
//        if let color {
//            mainView.backgroundColor = color
//        } else {
//            mainView.backgroundColor = .white
//        }
//        subTitleLabel.isHidden = subTitle == nil
//        titleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
//        subTitleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
//    }
    
}

