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
 
    
    public func pushSmilesExplorerMembershipSuccessVC(navVC: UINavigationController?,sourceScreen: SourceScreen = .success,onContinue:@escaping ()->Void) {
        let smilesExplorerMembershipSuccess = SmilesExplorerMembershipSuccessViewController(sourceScreen,onContinue: onContinue)
        navVC?.pushViewController(smilesExplorerMembershipSuccess, animated: true)
    }
    
    func pushSubscriptionVC(navVC: UINavigationController?) {
        let subVC = SmilesExplorerMembershipCardsViewController()
        navVC?.pushViewController(subVC, animated: true)
        
    }
    public func showPickTicketPop(viewcontroller: UIViewController)  {
        let picTicketPopUp = SmilesExplorerPickTicketPopUp()
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

}
