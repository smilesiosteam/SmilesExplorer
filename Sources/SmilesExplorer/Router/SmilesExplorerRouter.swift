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
    
    //MARK: - PROPERTIES
    public static let shared = SmilesExplorerRouter()
    
    //MARK: - INITIALIZER -
    private override init() {}
    
    //MARK: - PUSH TO OFFERVC -
    public func pushOffersVC(navVC:UINavigationController, delegate: SmilesExplorerHomeDelegate){
        let vc = SmilesExplorerOffersViewController()
        vc.delegate = delegate
        navVC.pushViewController(vc, animated: true)
    }
    
    //MARK: - PUSH TO EXPLORER HOME -
    public func pushSmilesExplorerMembershipSuccessVC(navVC: UINavigationController?,sourceScreen: SourceScreen = .success,packageType: String?,transactionId: String?,offerTitle: String ,onContinue:((String?) -> Void)?, onGoToExplorer:(()->Void)?) {
        let smilesExplorerMembershipSuccess = SmilesExplorerMembershipSuccessViewController(sourceScreen,packageType: packageType,transactionId: transactionId, offerTitle: offerTitle,onContinue: onContinue, onGoToExplorer: onGoToExplorer)
        navVC?.pushViewController(smilesExplorerMembershipSuccess, animated: true)
    }
    
    //MARK: - PUSH TO SUBSCRIPTIONVC -
    func pushSubscriptionVC(navVC: UINavigationController?, delegate:SmilesExplorerHomeDelegate?) {
        let subVC = SmilesExplorerMembershipCardsViewController()
        subVC.delegate = delegate
        navVC?.pushViewController(subVC, animated: true)
        
    }
    
    //MARK: - PUSH TO SCANNER VC -
    func pushQRScannerVC(navVC: UINavigationController) {
        let subVC = UIStoryboard(name: "SmilesExplorerQRCodeScanner", bundle: .module).instantiateViewController(withIdentifier: "SmilesExplorerQRCodeScannerViewController")
        navVC.pushViewController(subVC, animated: true)
    }
    
    //MARK: - PUSH TO EXPLORER OFFERS FILTERS -
    func pushSmilesExplorerOffersFiltersVC(navVC: UINavigationController?, delegate:SmilesExplorerHomeDelegate?) {
        let subVC = SmilesExplorerOffersFiltersVC()
        subVC.homeDelegate = delegate
        navVC?.pushViewController(subVC, animated: true)
    }
    
    //MARK: - PRESENT TO TICKET PICKER -
    public func showPickTicketPop(viewcontroller: UIViewController,delegate:SmilesExplorerHomeDelegate?)  {
        let picTicketPopUp = SmilesExplorerPickTicketPopUp()
        picTicketPopUp.modalPresentationStyle = .overFullScreen
        picTicketPopUp.paymentDelegate = delegate
        viewcontroller.present(picTicketPopUp)
    }
    
    //MARK: - POP EXPLORER HOME -
    public func popToSmilesExplorerHomeViewController(navVC: UINavigationController) {
        for controller in navVC.viewControllers as Array {
            if controller.isKind(of: SmilesExplorerHomeViewController.self) {
                navVC.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    //MARK: - POP EXPLORER SUBSCRIBED HOME -
    public func popToSmilesExplorerSubscriptionUpgradeViewController(navVC: UINavigationController) {
        for controller in navVC.viewControllers as Array {
            if controller.isKind(of: SmilesExplorerSubscriptionUpgradeViewController.self) {
                navVC.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    //MARK: - PUSH OFFER LISTING -
    func pushOffersListingVC(navVC: UINavigationController?, dependence: ExplorerOffersListingDependance, delegate:SmilesExplorerHomeDelegate?) {
        let vc = SmilesTouristConfigurator.getExplorerListingVC(dependence: dependence, delegate: delegate)
        navVC?.pushViewController(vc, animated: true)
        
    }
    //MARK: - Show OffersDetail -
    public func showOfferDetailPopup(viewcontroller: UIViewController, dependence: OfferDO, delegate:SmilesExplorerHomeDelegate?)  {
        let vc = SmilesTouristConfigurator.showOffersDetailVC(dependence: dependence, delegate: delegate)
        vc.modalPresentationStyle = .overFullScreen
        vc.navC = viewcontroller.navigationController
        viewcontroller.present(vc)
    }
    
    //MARK: - PUSH FAQs -
    func pushFAQsVC(navVC: UINavigationController?) {
        let vc = SmilesTouristConfigurator.getFAQsVC()
        navVC?.pushViewController(vc, animated: true)
    }
}

public class CustomPresentationController: UIPresentationController {
    public override var frameOfPresentedViewInContainerView: CGRect {
        // Customize the frame here as per your requirements
        return CGRect(x: 20, y: 100, width:UIScreen.main.bounds.width, height: 300)
    }
}
