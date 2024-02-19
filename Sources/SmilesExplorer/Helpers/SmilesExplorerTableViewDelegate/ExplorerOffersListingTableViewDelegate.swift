//
//  File.swift
//  
//
//  Created by Abdul Rehman Amjad on 08/02/2024.
//

import UIKit
import SmilesUtilities
import SmilesOffers
import NetworkingLayer
import SmilesLocationHandler

extension ExplorerOffersListingViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let offerUseCase = OffersDetailUsecase()
        let viewModel = OffersDetailViewModel(offerUseCase: offerUseCase)
        if let offerId = dependencies.offersResponse.offers?[safe: indexPath.row]?.offerId {
            viewModel.offerId = offerId
        }
        SmilesExplorerRouter.shared.showOfferDetailPopup(viewcontroller: self, viewModel: viewModel, delegate:delegate)
    
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let lastItem = offers.endIndex - 1
        if indexPath.row == lastItem {
            if (dependencies.offersResponse.offersCount ?? 0) != offers.count {
                offersPage += 1
                tableView.tableFooterView = PaginationLoaderView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 44))
                viewModel.getOffers(categoryId: dependencies.categoryId, tag: dependencies.offersTag, pageNo: offersPage)
            }
        }
        
    }
    
}
