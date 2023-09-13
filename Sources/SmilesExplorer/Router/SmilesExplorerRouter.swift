//
//  File.swift
//  
//
//  Created by Shmeel Ahmad on 14/08/2023.
//


import SmilesSharedServices
import SmilesUtilities
import UIKit

@objcMembers
public final class SmilesExplorerRouter: NSObject {
    
    public static let shared = SmilesExplorerRouter()
    
    private override init() {}
    
    public func pushOffersVC(navVC:UINavigationController){
        let vc = SmilesExplorerOffersViewController()
        navVC.pushViewController(vc, animated: true)
    }
 
    
    public func pushSmilesExplorerMembershipSuccessVC(navVC: UINavigationController?,sourceScreen: SourceScreen = .success,transactionId: String?,onContinue:((String?) -> Void)?) {
        let smilesExplorerMembershipSuccess = SmilesExplorerMembershipSuccessViewController(sourceScreen,transactionId: transactionId,onContinue: onContinue)
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
    
    
    public func showPickTicketPop(viewcontroller: UIViewController,delegate:SmilesExplorerHomeDelegate?)  {
        let picTicketPopUp = SmilesExplorerPickTicketPopUp()
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
    
    
    public func pushSmilesExplorerSubscriptionUpgradeViewController(navVC: UINavigationController?,sourceScreen: SourceScreen = .success,transactionId: String?,onContinue:((String?) -> Void)?) {
        let smilesExplorerMembershipSuccess = SmilesExplorerSubscriptionUpgradeViewController(categoryId: 973, isGuestUser: false, isUserSubscribed: true, subscriptionType: .gold, voucherCode: "")
        navVC?.pushViewController(smilesExplorerMembershipSuccess, animated: true)
    }

}
