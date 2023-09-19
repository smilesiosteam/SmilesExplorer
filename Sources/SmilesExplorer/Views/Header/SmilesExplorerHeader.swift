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
        if section == 2 {
            mainView.addMaskedCorner(withMaskedCorner: [.layerMinXMinYCorner, .layerMaxXMinYCorner], cornerRadius: 20.0)
        }
        if let color,section == 1{
            print(color)
            mainView.backgroundColor = .white
        }else {
            mainView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        }
        
        subTitleLabel.isHidden = subTitle == nil
        if isPostSub {
            subTitleLabel.isHidden = true
        }
        titleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
        subTitleLabel.semanticContentAttribute = AppCommonMethods.languageIsArabic() ? .forceRightToLeft : .forceLeftToRight
    }
    
}
