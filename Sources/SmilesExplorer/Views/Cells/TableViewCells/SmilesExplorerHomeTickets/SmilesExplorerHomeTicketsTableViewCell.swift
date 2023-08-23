//
//  SmilesExplorerHomeTicketsTableViewCell.swift
//  
//
//  Created by Abdul Rehman Amjad on 18/08/2023.
//

import UIKit

class SmilesExplorerHomeTicketsTableViewCell: UITableViewCell {

    // MARK: - OUTLETS -
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - PROPERTIES -
    var collectionsData: [ExplorerOffer]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }
    var callBack: ((ExplorerOffer) -> ())?
    
    // MARK: - ACTIONS -
    
    
    // MARK: - METHODS -
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        collectionView.register(UINib(nibName: String(describing: SmilesExplorerHomeTicketsCollectionViewCell.self), bundle: .module), forCellWithReuseIdentifier: String(describing: SmilesExplorerHomeTicketsCollectionViewCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = setupCollectionViewLayout()
        
    }
    
    private func setupCollectionViewLayout() ->  UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8)
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(128), heightDimension: .fractionalHeight(1)), subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            section.contentInsets.leading = 16
            section.contentInsets.trailing = 0
            return section
        }
    }
    
    func setBackGroundColor(color: UIColor) {
        mainView.backgroundColor = color
    }
    
}

// MARK: - COLLECTIONVIEW DELEGATE & DATASOURCE -
extension SmilesExplorerHomeTicketsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionsData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let data = collectionsData?[safe: indexPath.row] {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SmilesExplorerHomeTicketsCollectionViewCell", for: indexPath) as? SmilesExplorerHomeTicketsCollectionViewCell else {return UICollectionViewCell()}
            cell.configure(offer: data)
            cell.backgroundColor = .systemRed
            return cell
        }
        return UICollectionViewCell()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let data = collectionsData?[indexPath.row] {
            callBack?(data)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width/4, height: 140)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Set the section insets
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20.0
    }
    
    
    
}
