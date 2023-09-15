//
//  RestaurantSortingViewController.swift
//  House
//
//  Created by Hannan on 27/09/2020.
//  Copyright © 2020 Ahmed samir ali. All rights reserved.
//

import Foundation
import UIKit
import SmilesUtilities
import SmilesOffers



class SmilesExplorerSortingVC: UIViewController {
    
    // MARK: Properties
    
    
    
    // MARK: IBOutlets
    @IBOutlet weak var view_Segue: UIView!
    @IBOutlet weak var view_header: UIView!
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.font = .montserratSemiBoldFont(size: 17.0)
            titleLabel.text = "SortbyTitle".localizedString
            titleLabel.textColor = .appDarkGrayColor
        }
    }
    
    @IBOutlet weak var sortingTableView: UITableView! {
        didSet{
            sortingTableView.delegate = self
            sortingTableView.dataSource = self
        }
    }
         
     var panScrollable: UIScrollView? {
         return nil
     }
     
     
     
     
    var showDragIndicator: Bool {
        return false
    }
     
     var anchorModalToLongForm: Bool {
         return false
     }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        
    }
    
    func setUpView() {
        view_Segue.RoundedViewConrner(cornerRadius: 3)
        
    }
    
    
    
}






extension SmilesExplorerSortingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SmilesExplorerSortingTVC.self), for: indexPath) as! SmilesExplorerSortingTVC
        
        return cell 
    }
    
    
}
