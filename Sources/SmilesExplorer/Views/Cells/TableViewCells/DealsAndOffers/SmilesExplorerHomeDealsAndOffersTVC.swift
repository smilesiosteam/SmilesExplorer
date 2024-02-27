//
//  SmilesExplorerHomeDealsAndOffersTVC.swift
//
//
//  Created by Habib Rehman on 15/09/2023.
//

import UIKit
import SmilesOffers

class SmilesExplorerHomeDealsAndOffersTVC: UITableViewCell {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - PROPERTIES -
    var index: Int?
    var callBack: ((OfferDO) -> ())?
    var collectionsData: [OfferDO]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - SETUPUI
    private func setupViews() {
        mainView.backgroundColor = .clear
        collectionView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        setupCollectionView()
    }
    
    // MARK: - SETUP COLLECTIONVIEW
    private func setupCollectionView() {
        
        collectionView.register(UINib(nibName: String(describing: SmilesExplorerDealsAndOffersCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: SmilesExplorerDealsAndOffersCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(96), heightDimension: .absolute(108)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 8)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(96), heightDimension: .absolute(124)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 16
            
            return section
        }
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
    
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE -
extension SmilesExplorerHomeDealsAndOffersTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let data = collectionsData?[safe: indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmilesExplorerDealsAndOffersCollectionViewCell", for: indexPath) as? SmilesExplorerDealsAndOffersCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(offer: data)
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = collectionsData?[safe: indexPath.row] {
            callBack?(data)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 96.0, height: 128.0)
    }
}
