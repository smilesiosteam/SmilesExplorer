//
//  StoriesTableViewCell.swift
//  House
//
//  Created by Shahroze Zaheer on 10/26/22.
//  Copyright © 2022 Ahmed samir ali. All rights reserved.
//

import UIKit
import SmilesOffers

public class SmilesExplorerStoriesTVC: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
     var collectionsData: [OfferDO]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }
    
    var callBack: ((OfferDO) -> ())?
    var StoriesCallBacK:((OfferDO) -> ())?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.register(UINib(nibName: String(describing: SmilesExplorerStoriesCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: SmilesExplorerStoriesCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1)
        collectionView.collectionViewLayout = setupCollectionViewLayout()
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in

            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 12)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(116), heightDimension: .absolute(215)), subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets.leading = 16
            return section
        }

        return layout
    }
    
    public func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
}

extension SmilesExplorerStoriesTVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let storyOffer = collectionsData?[indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmilesExplorerStoriesCollectionViewCell", for: indexPath) as? SmilesExplorerStoriesCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(storyOffer: storyOffer)
            return cell
        }
        
        return UICollectionViewCell()
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = collectionsData?[indexPath.row] {
            callBack?(data)
            StoriesCallBacK?(data)
        }
        
        
    }
    
    
}
