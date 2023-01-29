//
//  ChangeLanguageViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/10/2022.
//

import UIKit

class ChangeLanguageViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var englishView: UIView!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var englishButtonOutlet: UIButton!
    
    @IBOutlet weak var arabicView: UIView!
    @IBOutlet weak var arabicLabel: UILabel!
    @IBOutlet weak var arabicButtonOutlet: UIButton!
    
    let firstColor = DesignSystem.Colors.PrimaryBlue.color
    let secondColor = DesignSystem.Colors.PrimaryOrange.color
    
    var flage = false
    var lang = "en"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppLocalization.currentAppleLanguage() == "en" {
            
            englishView.setGradient(firstColor: firstColor, secondColor: secondColor)
            DispatchQueue.main.async {
                self.arabicView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
                self.englishLabel.textColor = .white
                self.arabicLabel.textColor = .black
            }
            
        }else {
            
            arabicView.setGradient(firstColor: firstColor, secondColor: secondColor)
            DispatchQueue.main.async {
                self.englishView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
                self.arabicLabel.textColor = .white
                self.englishLabel.textColor = .black
            }
            
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func englishTapped(_ sender: Any) {
        englishView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.arabicView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.englishLabel.textColor = .white
            self.arabicLabel.textColor = .black
            
            self.flage = false
            self.lang = "en"
            
        }
    }
    
    @IBAction func arabicTapped(_ sender: Any) {
        arabicView.setGradient(firstColor: firstColor, secondColor: secondColor)
        DispatchQueue.main.async {
            self.englishView.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
            self.arabicLabel.textColor = .white
            self.englishLabel.textColor = .black
            
            self.flage = true
            self.lang = "ar"
            
        }
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        if flage == true {
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            let storyboard = UIStoryboard(name: "HawyTabbar", bundle: nil)
            rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: "HawyTabbarController")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            
            UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromRight, animations: { () -> Void in
            }) { (finished) -> Void in
                
                AppLocalization.setAppleLAnguageTo(lang: self.lang)
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
                
                // Refresh The View To Reload The View
                let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
            
        }else {
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            let storyboard = UIStoryboard(name: "HawyTabbar", bundle: nil)
            rootviewcontroller.rootViewController = storyboard.instantiateViewController(withIdentifier: "HawyTabbarController")
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            
            UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromRight, animations: { () -> Void in
            }) { (finished) -> Void in
                
                AppLocalization.setAppleLAnguageTo(lang: self.lang)
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                
                // Refresh The View To Reload The View
                let story = UIStoryboard(name: "HawyTabbar", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "HawyTabbarController") as! HawyTabbarController
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
            
        }
        
    }
    
}
