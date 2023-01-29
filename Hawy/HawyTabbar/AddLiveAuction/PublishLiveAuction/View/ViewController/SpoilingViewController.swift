//
//  SpoilingViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 12/11/2022.
//

import UIKit

class SpoilingViewController: UIViewController {
    
    var backdata: ((String) -> Void)?
    
    var spoiling = ""
    
    @IBOutlet weak var spoiltAdminImage: UIImageView!
    @IBOutlet weak var spoiltMeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    @IBAction func spoiltAdminButtonTapped(_ sender: Any) {
        
        spoiltAdminImage.image = UIImage(named: "TOGGLE-1")
        spoiltMeImage.image = UIImage(named: "TOGGLE")
        
        spoiling = "admin"
        
    }
    
    @IBAction func spoiltmeButtonTapped(_ sender: Any) {
        
        spoiltAdminImage.image = UIImage(named: "TOGGLE")
        spoiltMeImage.image = UIImage(named: "TOGGLE-1")
        
        spoiling = "me"
        
    }
    
    @IBAction func chooseButtonAction(_ sender: Any) {
        
        dismiss(animated: true) {
            self.backdata?(self.spoiling)
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
