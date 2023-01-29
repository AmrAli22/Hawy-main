//
//  HawyTabbarController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 07/08/2022.
//

import UIKit

enum CustomTabBarButtons: Int {
    case homeVC
    case mazaVC
    case AddAuctionsTBVC
    case profileVC
    case settingsVC
}

class HawyTabbarController: UIViewController {
    
    @IBOutlet weak var contentView  : UIView!
    @IBOutlet weak var viewForTab   : UIView!
    
    @IBOutlet weak var homeIcon     : UIImageView!
    @IBOutlet weak var mazadIcon     : UIImageView!
    @IBOutlet weak var profileIcon   : UIImageView!
    @IBOutlet weak var settingIcon  : UIImageView!
    
    @IBOutlet weak var homeDot: GradientView!
    @IBOutlet weak var mazadDot: GradientView!
    @IBOutlet weak var profileDot: GradientView!
    @IBOutlet weak var settingDot: GradientView!
    
    
    @IBOutlet weak var addAuctionView: UIView!
    @IBOutlet weak var addAuctionImage: UIImageView!
    @IBOutlet weak var addAuctionButtonOutlet: UIButton!
    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var auctionsView: GradientView!
    @IBOutlet weak var maskImage: UIImageView!
    @IBOutlet weak var downButtonOutlet: UIButton!
    
    var homeVC: UIViewController!
    var mazaVC: UIViewController!
    var profileVC: UIViewController!
    var settingsVC: UIViewController!
    var AddAuctionsTBVC: UIViewController!
    
    var viewControllers: [UIViewController]!
    var selectedIndex: Int = 0
    
    var isAddCard = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyborad = UIStoryboard(name: "HawyTabbar", bundle: nil)
        
        homeVC = storyborad.instantiateViewController(withIdentifier: "HomeVC")
        mazaVC = storyborad.instantiateViewController(withIdentifier: "BaseAuctionsViewController")
        AddAuctionsTBVC = storyborad.instantiateViewController(withIdentifier: "AddAuctionsTBViewController")
        
        profileVC = storyborad.instantiateViewController(withIdentifier: "ProfileViewController")
        settingsVC = storyborad.instantiateViewController(withIdentifier: "SettingViewController")
        viewControllers = [homeVC, mazaVC, AddAuctionsTBVC, profileVC, settingsVC] //, mazaVC, profileVC, settingsVC
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            //self.forHome()
            
            if self.isAddCard == false {
                self.forSwitchControllers(type: .homeVC)
            }else {
                self.forSwitchControllers(type: .profileVC)
            }
            
            self.view.bringSubviewToFront(self.maskImage)
            self.view.bringSubviewToFront(self.opacityView)
            self.view.bringSubviewToFront(self.auctionsView)
            self.view.bringSubviewToFront(self.downButtonOutlet)
            self.opacityView.isHidden = true
            self.auctionsView.isHidden = true
            self.maskImage.isHidden = true
            self.downButtonOutlet.isHidden = true
            self.addAuctionView.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage          =  UIImage()
        navigationController?.navigationBar.barTintColor         =  .white
        navigationController?.navigationBar.tintColor            =  .white
        navigationController?.navigationBar.titleTextAttributes  =  [.foregroundColor: UIColor.white]
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        auctionsView.roundCorners([.topLeft, .topRight], radius: 20)
        //addAuctionImage.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func forSwitchControllers(type: CustomTabBarButtons) {
        
        //guard let Home = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC else { return }
        //guard let Home = UIStoryboard(name: "YastronTabbar", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC else { return }
        
        //addChild(Home)
        //contentView.addSubview(Home.view)
        //Home.didMove(toParent: self)
        
        let previousIndex = selectedIndex
        selectedIndex = type.rawValue
        
        let previousVC = viewControllers[previousIndex]
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
        let vc = viewControllers[selectedIndex]
        addChild(vc)
        vc.view.frame = contentView.bounds
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        switch type {
        case .homeVC:
            
            // home1 // auctions // Contacts-1 //Settings-1
            // Path 14716 // Search results for Auctions - Flaticon-1 // Union 23 //Settings
            homeIcon.image = UIImage(named: "home1")
            mazadIcon.image = UIImage(named: "Search results for Auctions - Flaticon-1")
            profileIcon.image = UIImage(named: "Union 23")
            settingIcon.image = UIImage(named: "Settings")
            
            addAuctionButtonOutlet.isHidden = false
            addAuctionView.isHidden = false
            opacityView.isHidden = true
            maskImage.isHidden = true
            downButtonOutlet.isHidden = true
            auctionsView.isHidden = true
            
            homeDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            homeDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            homeDot.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
            
            mazadDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            mazadDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            mazadDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            profileDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            profileDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            profileDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            settingDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            settingDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            settingDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
        case .mazaVC:
            
            homeIcon.image = UIImage(named: "Path 14716")
            mazadIcon.image = UIImage(named: "auctions")
            profileIcon.image = UIImage(named: "Union 23")
            settingIcon.image = UIImage(named: "Settings")
            
            addAuctionButtonOutlet.isHidden = false
            addAuctionView.isHidden = false
            opacityView.isHidden = true
            maskImage.isHidden = true
            downButtonOutlet.isHidden = true
            auctionsView.isHidden = true
            
            homeDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            homeDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            homeDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            mazadDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            mazadDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            mazadDot.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
            
            profileDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            profileDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            profileDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            settingDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            settingDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            settingDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
        case .profileVC:
            
            homeIcon.image = UIImage(named: "Path 14716")
            mazadIcon.image = UIImage(named: "Search results for Auctions - Flaticon-1")
            profileIcon.image = UIImage(named: "Contacts-1")
            settingIcon.image = UIImage(named: "Settings")
            
            addAuctionButtonOutlet.isHidden = false
            addAuctionView.isHidden = false
            opacityView.isHidden = true
            maskImage.isHidden = true
            downButtonOutlet.isHidden = true
            auctionsView.isHidden = true
            
            homeDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            homeDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            homeDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            mazadDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            mazadDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            mazadDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            profileDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            profileDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            profileDot.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
            
            settingDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            settingDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            settingDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
        case .settingsVC:
            
            homeIcon.image = UIImage(named: "Path 14716")
            mazadIcon.image = UIImage(named: "Search results for Auctions - Flaticon-1")
            profileIcon.image = UIImage(named: "Union 23")
            settingIcon.image = UIImage(named: "Settings-1")
            
            addAuctionButtonOutlet.isHidden = false
            addAuctionView.isHidden = false
            opacityView.isHidden = true
            maskImage.isHidden = true
            downButtonOutlet.isHidden = true
            auctionsView.isHidden = true
            
            homeDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            homeDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            homeDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            mazadDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            mazadDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            mazadDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            profileDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            profileDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            profileDot.gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            
            settingDot.gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            settingDot.gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
            settingDot.gradientLayer.colors = [DesignSystem.Colors.PrimaryBlue.color.cgColor, DesignSystem.Colors.PrimaryOrange.color.cgColor]
            
        case .AddAuctionsTBVC:
            
            addAuctionButtonOutlet.isHidden = false
            addAuctionView.isHidden = false
            opacityView.isHidden = true
            maskImage.isHidden = true
            downButtonOutlet.isHidden = true
            auctionsView.isHidden = true
            
        }
        
    }
    
    @IBAction func onClickTabBar(_ sender: UIButton) {
        
        let tag = sender.tag
        print(tag)
        
        if tag == 1 {
            
//            forHome()
//
//            homeIcon.tintColor     =  #colorLiteral(red: 0.9981513619, green: 0.8029696941, blue: 0.220695734, alpha: 1)
//            cartIcon.tintColor     =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            offersIcon.tintColor   =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            settingIcon.tintColor  =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            forSwitchControllers(type: .homeVC)
            
        }else if tag == 2 {
            
//            guard let Cart = UIStoryboard(name: "EDTabbar", bundle: nil).instantiateViewController(withIdentifier: "CartVC") as? CartVC else { return }
//            Cart.backVieweight = 0
//            Cart.emptyState = 0
            
//            addChild(Cart)
//            contentView.addSubview(Cart.view)
//            Cart.didMove(toParent: self)
//
//            homeIcon.tintColor     =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            cartIcon.tintColor     =  #colorLiteral(red: 0.9981513619, green: 0.8029696941, blue: 0.220695734, alpha: 1)
//            offersIcon.tintColor   =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            settingIcon.tintColor  =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
                
                let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                    
                    
                    let story = UIStoryboard(name: "Authentication", bundle:nil)
                    let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                
            }else {
                
                forSwitchControllers(type: .mazaVC)
                
            }
            
            
            
        }else if tag == 3 {
            
//            guard let Offer = UIStoryboard(name: "EDTabbar", bundle: nil).instantiateViewController(withIdentifier: "OffersVC") as? OffersVC else { return }
//            addChild(Offer)
//            contentView.addSubview(Offer.view)
//            Offer.didMove(toParent: self)
//
//            homeIcon.tintColor     =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            cartIcon.tintColor     =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            offersIcon.tintColor   =  #colorLiteral(red: 0.9981513619, green: 0.8029696941, blue: 0.220695734, alpha: 1)
//            settingIcon.tintColor  =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
            if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
                
                let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                    
                    
                    let story = UIStoryboard(name: "Authentication".localized, bundle:nil)
                    let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
                
            }else {
                
                forSwitchControllers(type: .profileVC)
                
            }
            
            
            
        }else if tag == 4 {
            
//            guard let Profile = UIStoryboard(name: "EDTabbar", bundle: nil).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC else { return }
//            addChild(Profile)
//            contentView.addSubview(Profile.view)
//            Profile.didMove(toParent: self)
//
//            homeIcon.tintColor     =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            cartIcon.tintColor     =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            offersIcon.tintColor   =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
//            settingIcon.tintColor  =  #colorLiteral(red: 0.9981513619, green: 0.8029696941, blue: 0.220695734, alpha: 1)
            
            forSwitchControllers(type: .settingsVC)
            
        }else {
            //forSwitchControllers(type: .AddAuctionsTBVC)
        }
        
    }
    
    @IBAction func downButtonTapped(_ sender: Any) {
        
        addAuctionButtonOutlet.isHidden = false
        addAuctionView.isHidden = false
        opacityView.isHidden = true
        maskImage.isHidden = true
        downButtonOutlet.isHidden = true
        auctionsView.isHidden = true
        
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        
        opacityView.isHidden = false
        auctionsView.isHidden = false
        maskImage.isHidden = false
        downButtonOutlet.isHidden = false
        addAuctionButtonOutlet.isHidden = true
        addAuctionView.isHidden = true
        
        
    }
    
    @IBAction func saleAuctionButtonAction(_ sender: Any) {
        
        if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
            
            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                
                
                let story = UIStoryboard(name: "Authentication", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            
        }else {
            
            let stroyboard = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = stroyboard.instantiateViewController(withIdentifier: "AddSaleAuctionFromHomeViewController") as? AddSaleAuctionFromHomeViewController
            navigationController?.pushViewController(VC!, animated: true)
            
        }
        
        
        
    }
    
    @IBAction func liveAuctionButtonAction(_ sender: Any) {
        
        if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
            
            let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                
                
                let story = UIStoryboard(name: "Authentication", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                UIApplication.shared.windows.first?.makeKeyAndVisible()
                
            }
            let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            
        }else {
            
            let stroyboard = UIStoryboard(name: "Auctions", bundle: nil)
            let VC = stroyboard.instantiateViewController(withIdentifier: "PublishLiveAuctionViewController") as? PublishLiveAuctionViewController
            navigationController?.pushViewController(VC!, animated: true)
            
        }
        
        
        
    }
    
}
