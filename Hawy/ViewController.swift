//
//  ViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/08/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TappedButtonOutlet: UIButton!
    @IBOutlet weak var TappedButtonTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //TappedButtonOutlet.backgroundColor = DesignSystem.Colors.PrimaryColor.color
        TappedButtonOutlet.titleLabel?.font = DesignSystem.Typography.bigButton.font
        TappedButtonOutlet.buttonPulsate()
    }
    
    //MARK:- Favourite Button Action
    @IBAction func TappedButtonAction(_ sender: Any) {
        
        TappedButtonTopConstraint.constant = 50
        
        let animator = DesignSystem.AnimationDesignSystem.easeIn(duration: .normal).animator
        
        animator.addAnimations {
            self.view.layoutIfNeeded()
        }
        
        animator.startAnimation()
        
    }
    
}

