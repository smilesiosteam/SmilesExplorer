//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 14/08/2023.
//


import SmilesSharedServices
import SmilesUtilities
import UIKit
import SmilesOffers

@objcMembers
public final class SmilesExplorerRouter: NSObject {
    
    public static let shared = SmilesExplorerRouter()
    
    private override init() {}
    
    public func pushOffersVC(navVC:UINavigationController, delegate: SmilesExplorerHomeDelegate){
        let vc = SmilesExplorerOffersViewController()
        vc.delegate = delegate
        navVC.pushViewController(vc, animated: true)
    }
 
    
    public func pushSmilesExplorerMembershipSuccessVC(navVC: UINavigationController?,sourceScreen: SourceScreen = .success,packageType: String?,transactionId: String?,offerTitle: String ,onContinue:((String?) -> Void)?, onGoToExplorer:(()->Void)?) {
        let smilesExplorerMembershipSuccess = SmilesExplorerMembershipSuccessViewController(sourceScreen,packageType: packageType,transactionId: transactionId, offerTitle: offerTitle,onContinue: onContinue, onGoToExplorer: onGoToExplorer)
        navVC?.pushViewController(smilesExplorerMembershipSuccess, animated: true)
    }
    
    func pushSubscriptionVC(navVC: UINavigationController?, delegate:SmilesExplorerHomeDelegate?) {
        let subVC = SmilesExplorerMembershipCardsViewController()
        subVC.delegate = delegate
        navVC?.pushViewController(subVC, animated: true)
        
    }
    
    func pushQRScannerVC(navVC: UINavigationController) {
        let subVC = UIStoryboard(name: "SmilesExplorerQRCodeScanner", bundle: .module).instantiateViewController(withIdentifier: "SmilesExplorerQRCodeScannerViewController")
        navVC.pushViewController(subVC, animated: true)
    }
    
    
    func pushSmilesExplorerSortingVC(navVC: UINavigationController) {
        let subVC = UIStoryboard(name: "SmilesExplorerSortingVC", bundle: .module).instantiateViewController(withIdentifier: "SmilesExplorerSortingVC")
        navVC.present(subVC)
    }
    
    
    func pushSmilesExplorerOffersFiltersVC(navVC: UINavigationController?, delegate:SmilesExplorerHomeDelegate?) {
        let subVC = SmilesExplorerOffersFiltersVC()
        subVC.homeDelegate = delegate
        navVC?.pushViewController(subVC, animated: true)
        
    }
    
    
    public func showPickTicketPop(viewcontroller: UIViewController,delegate:SmilesExplorerHomeDelegate?)  {
        let picTicketPopUp = SmilesExplorerPickTicketPopUp()
        picTicketPopUp.modalPresentationStyle = .overFullScreen
        picTicketPopUp.paymentDelegate = delegate
        viewcontroller.present(picTicketPopUp)
    }

    public func popToSmilesExplorerHomeViewController(navVC: UINavigationController) {
        for controller in navVC.viewControllers as Array {
            if controller.isKind(of: SmilesExplorerHomeViewController.self) {
                navVC.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    public func popToSmilesExplorerSubscriptionUpgradeViewController(navVC: UINavigationController) {
        for controller in navVC.viewControllers as Array {
            if controller.isKind(of: SmilesExplorerSubscriptionUpgradeViewController.self) {
                navVC.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    func pushOffersListingVC(navVC: UINavigationController?, offersResponse: OffersCategoryResponseModel, title: String) {
        
        let vc = ExplorerOffersListingViewController(offersResponse: offersResponse, title: title)
        navVC?.pushViewController(vc, animated: true)
        
    }
    
    
//    public func pushSmilesExplorerSubscriptionUpgradeViewController(navVC: UINavigationController?, delegate:SmilesExplorerHomeDelegate, sourceScreen: SourceScreen = .success,transactionId: String?,onContinue:((String?) -> Void)?) {
//        let smilesExplorerMembershipSuccess = SmilesExplorerSubscriptionUpgradeViewController(categoryId: 973, isGuestUser: false, isUserSubscribed: true, subscriptionType: .gold, voucherCode: "", delegate: delegate)
//        navVC?.pushViewController(smilesExplorerMembershipSuccess, animated: true)
//    }

}


public class CustomPresentationController: UIPresentationController {
    public override var frameOfPresentedViewInContainerView: CGRect {
        // Customize the frame here as per your requirements
        return CGRect(x: 20, y: 100, width:UIScreen.main.bounds.width, height: 300)
    }
}
