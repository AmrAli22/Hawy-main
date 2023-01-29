//
//  WelcomrDescriptionViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 23/12/2022.
//

import UIKit

class WelcomrDescriptionViewController: UIViewController {
    
    @IBOutlet weak var titleLAbel: UILabel!
    @IBOutlet weak var dateLAbel: UILabel!
    @IBOutlet weak var descTV: UITextView!
    
    var welcomeTitle: String?
    var desc: String?
    var date: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLAbel.text = welcomeTitle
        dateLAbel.text = date
        descTV.text = desc
        
    }
    
    @IBAction func backHomeButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
