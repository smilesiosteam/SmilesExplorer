//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 14/08/2023.
//

import SmilesUtilities
import SmilesLanguageManager
import UIKit

class SmilesExplorerHeader: UIView {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var titleLabel: UILocalizableLabel!
    @IBOutlet weak var subTitleLabel: UILocalizableLabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bgMainView: UIView!
    
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
        Bundle.module.loadNibNamed("SmilesExplorerHeader", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = bounds
        mainView.bindFrameToSuperviewBounds()
    }
    
    func setupData(title: String?, subTitle: String?, color: UIColor?,section:Int?, isPostSub:Bool = false) {
        titleLabel.localizedString = title ?? ""
        if !isPostSub {
            subTitleLabel.localizedString = subTitle ?? ""
        }
        
        
        
        subTitleLabel.isHidden = subTitle == nil
        if isPostSub {
            subTitleLabel.isHidden = true
        }
        titleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        subTitleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
    }
    
}
