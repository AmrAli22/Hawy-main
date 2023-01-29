//
//  SettingViewController.swift
//  Hawy
//
//  Created by ahmed abu elregal on 04/10/2022.
//

import UIKit
import Alamofire

// MARK: - AddSaleAuctionModel
struct SocialModel: Codable {
    let code: Int?
    let message: String?
    let item: SocialItem?
}

// MARK: - Item
struct SocialItem: Codable {
    let whats, instagram, appStore: String?
}

class SettingViewController: BaseViewViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var logoutViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var notificationButton: UIButton!
    
    var appStore: String?
    var whatsApp: String?
    var instagram: String?
    
    weak var homeVC: HomeVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if HelperConstant.getToken() == "" || HelperConstant.getToken() == nil {
            
            logoutView.isHidden = true
            logoutViewHeight.constant = 0
            
        }else {
            
            logoutView.isHidden = false
            logoutViewHeight.constant = 65
            
        }
        
        getSocialData()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readNotification()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    func readNotification() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")"
        ]
        
        //showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/notifications/status", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(ReadNotificationModel.self, from: response.data!)
                
                if productResponse.message == "Unauthenticated." {
                    
                    let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                        
                        
                        let story = UIStoryboard(name: "Authentication", bundle:nil)
                        let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                    }
                    //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    //alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                //
                if productResponse.item?.status == true {
                    self.notificationButton.setImage(UIImage(named: "notification"), for: .normal)
                }else {
                    self.notificationButton.setImage(UIImage(named: "Group 52267"), for: .normal)
                }
                
                //self.hideIndecator()
            } catch {
                //self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    func getSocialData() {
        
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json",
            "Accept-Language":AppLocalization.currentAppleLanguage(),
            "Authorization": "Bearer \(HelperConstant.getToken() ?? "")",
            "offset": "\(HelperConstant.getOffst() ?? 0)"
        ]
        
        showIndecator() //?user_id=20
        AF.request("https://hawy-kw.com/api/socail", method: .get, parameters: nil, headers: headers)
            .validate(statusCode: 200...500)
            .responseJSON { (response) in
            print(response)
            
            do {
                let productResponse = try JSONDecoder().decode(SocialModel.self, from: response.data!)
                
                if productResponse.message == "Unauthenticated." {
                    
                    let alert = UIAlertController(title: "Login".localized, message: "please, login".localized, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
                        
                        
                        let story = UIStoryboard(name: "Authentication", bundle:nil)
                        let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                        
                    }
                    //let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    //alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
                if productResponse.code == 200 {
                    print("success")
                    
                    self.whatsApp = productResponse.item?.whats
                    self.instagram = productResponse.item?.instagram
                    self.appStore = productResponse.item?.appStore
                    
                }
                self.hideIndecator()
            } catch {
                self.hideIndecator()
                // self.NoInternetConnectionMessage()
            }
        }
    }
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Notifications", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        
        navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func packageTapped(_ sender: Any) {
        
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
            
            let storyboard = UIStoryboard(name: "Setting", bundle: nil)
            let VC = storyboard.instantiateViewController(withIdentifier: "MyPackagesViewController") as! MyPackagesViewController
            if homeVC != nil {
                self.dismiss(animated: false) {
                    self.homeVC?.navigationController?.pushViewController(VC, animated: false)
                }
            }else {
                navigationController?.pushViewController(VC, animated: true)
            }
            
        }
        
    }
    
    @IBAction func fingerTapped(_ sender: Any) {
        
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
            
//            let stroyboard = UIStoryboard(name: "Auctions", bundle: nil)
//            let VC = stroyboard.instantiateViewController(withIdentifier: "PublishLiveAuctionViewController") as? PublishLiveAuctionViewController
//            navigationController?.pushViewController(VC!, animated: true)
            
        }
        
    }
    
    @IBAction func languageTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ChangeLanguageViewController") as! ChangeLanguageViewController
        
        if homeVC != nil {
            self.dismiss(animated: false) {
                self.homeVC?.navigationController?.pushViewController(VC, animated: false)
            }
        }else {
            navigationController?.pushViewController(VC, animated: true)
        }
        
        
        
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        // text to share
        //let titleText = "Share App Link"
        var text = appStore
        
        if text?.isEmpty == true || text == nil || text == "" {
            text = "لا يوجد لينك للتطبيق حاليا"
        }else {
            text = appStore
        }
        
        // set up activity view controller
        let textToShare = [/*titleText, */text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.message,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.markupAsPDF,
            UIActivity.ActivityType.airDrop
        ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func whoUsTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "WhoUSViewController") as! WhoUSViewController
        if homeVC != nil {
            self.dismiss(animated: false) {
                self.homeVC?.navigationController?.pushViewController(VC, animated: false)
            }
        }else {
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @IBAction func contactUsTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "ContactUSViewController") as! ContactUSViewController
        if homeVC != nil {
            self.dismiss(animated: false) {
                self.homeVC?.navigationController?.pushViewController(VC, animated: false)
            }
        }else {
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @IBAction func termsTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        if homeVC != nil {
            self.dismiss(animated: false) {
                self.homeVC?.navigationController?.pushViewController(VC, animated: false)
            }
        }else {
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @IBAction func questionsTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "PopularQuestionsViewController") as! PopularQuestionsViewController
        if homeVC != nil {
            self.dismiss(animated: false) {
                self.homeVC?.navigationController?.pushViewController(VC, animated: false)
            }
        }else {
            navigationController?.pushViewController(VC, animated: true)
        }
        
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout".localized, message: "Are you sure, want to logout ?".localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok".localized, style: .default) { action in
            
            UserDefaults.standard.setValue(nil, forKey: "access_token")
            UserDefaults.standard.setValue(nil, forKey: "userId")
            let story = UIStoryboard(name: "Authentication", bundle:nil)
            let vc = story.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            UIApplication.shared.windows.first?.rootViewController = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func InstaTapped(_ sender: Any) {
        
        if let url = URL(string: instagram ?? ""),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened) {
                    print("whatsApp Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
        
    }
    
    @IBAction func whatsAppTapped(_ sender: Any) {
        
        if let url = URL(string: whatsApp ?? ""),
           UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:]) { (opened) in
                if(opened) {
                    print("whatsApp Opened")
                }
            }
        } else {
            print("Can't Open URL on Simulator")
        }
        
    }
    
//    @IBAction func risiButtonTapped(_ sender: Any) {
//        
//        if let url = URL(string: "https://risi-Kw.com") {
//            UIApplication.shared.open(url, options: [:])
//        }
//        
//    }
    
    
}
