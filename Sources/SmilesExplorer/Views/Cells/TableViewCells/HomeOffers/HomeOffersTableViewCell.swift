//
//  HomeOffersTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 18/08/2023.
//

import UIKit
import SmilesOffers
import SmilesUtilities

class HomeOffersTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var mainView: UICustomView!
    @IBOutlet weak var offerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - PROPERTIES -
    private var collectionsData: [OfferDO]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }
    var section: SmilesExplorerSectionIdentifier = .tickets
    weak var delegate: HomeOffersDelegate?
    
    // MARK: - ACTIONS -
    @IBAction func viewAllPressed(_ sender: Any) {
        delegate?.showOffersList(section: section)
    }
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        
        let isLanguageArabic = AppCommonMethods.languageIsArabic()
        viewAllButton.semanticContentAttribute = isLanguageArabic ? .forceLeftToRight : .forceRightToLeft
        viewAllButton.setImage(UIImage(named: isLanguageArabic ? "back_icon" : "back_icon_ar", in: .module, with: nil), for: .normal)
        viewAllButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: isLanguageArabic ? 0 : -2,
                                                     bottom: 0, right: isLanguageArabic ? -2 : 0)
        viewAllButton.contentHorizontalAlignment = isLanguageArabic ? .left : .right
        mainView.backgroundColor = .clear
        offerImageView.layer.cornerRadius = offerImageView.frame.height / 2
        offerImageView.clipsToBounds = true
        setupCollectionView()
        
    }
    
    private func setupCollectionView() {
        
        collectionView.register(UINib(nibName: String(describing: HomeOffersCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: HomeOffersCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
    
    func setupData(offers: [OfferDO]?, title: String?, subtitle: String?, offersImage: String?, section: SmilesExplorerSectionIdentifier) {
        
        offerImageView.setImageWithUrlString(offersImage ?? "")
        titleLabel.text = title
        subtitleLabel.text = subtitle
        self.section = section
        collectionsData = offers
        
    }
    
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE -
extension HomeOffersTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let data = collectionsData?[safe: indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeOffersCollectionViewCell", for: indexPath) as? HomeOffersCollectionViewCell else {return UICollectionViewCell()}
            cell.setupData(offer: data, isForTickets: section == .tickets)
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let data = collectionsData?[indexPath.row] {
            delegate?.showOfferDetails(offer: data)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 135, height: 200)
    }
}
