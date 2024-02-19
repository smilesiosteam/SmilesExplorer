//
//  File.swift
//  
//
//  Created by Habib Rehman on 15/02/2024.
//sectionIdentifier

import Foundation
import UIKit
import SmilesFontsManager

class OffersPopupHeaderView: UITableViewHeaderFooterView {
    
    //MARK: - Title Label
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.fontTextStyle = .smilesHeadline2
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
