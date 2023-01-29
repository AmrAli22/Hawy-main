//
//  PaymetViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 02/11/2022.
//

import UIKit

class PaymetViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        let stroyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
        let VC = stroyboard.instantiateViewController(withIdentifier: "SuccessPaymentViewController") as? SuccessPaymentViewController
        present(VC!, animated: true, completion: nil)
        //self.navigationController?.pushViewController(VC!, animated: true)
        
    }
    
}
