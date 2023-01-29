//
//  SuccessPaymentViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 02/11/2022.
//

import UIKit

class SuccessPaymentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func homeButtonTapped(_ sender: Any) {
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        let VC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
        VC?.myProfile = true
        VC?.startWithAuctions = true
//        VC?.ownerId = item.id
//        VC?.newName = item.name ?? ""
//        VC?.newPhone = item.mobile ?? ""
//        VC?.newImage = item.image ?? ""
//        VC?.newCode = item.code ?? ""
   //     print(item.id)
        //sepresent(VC!, animated: true, completion: nil)
        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: VC!)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        
        //BackHere
//        let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
//        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
    }
    
}
